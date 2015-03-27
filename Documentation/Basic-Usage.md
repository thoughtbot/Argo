## Usage

The first thing you need to do when you receive JSON data is convert it to an
instance of the `JSONValue` enum. This is done by passing the `AnyObject`
value returned from `NSJSONSerialization` to `JSONValue.parse()`:

```swift
let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions(0), error: nil)

if let j: AnyObject = json {
  let value: JSONValue = JSONValue.parse(j)
  let user: User? = User.decode(value)
}
```

Note that you probably want to use an error pointer to track errors from
`NSJSONSerialization`.

The `JSONValue` enum exists to help with some of the type inference, and also
wraps up some of the casting that we'll need to to to transform the JSON into
native types.

Next, you need to make sure that models that you wish to decode from JSON
conform to the `JSONDecodable` protocol:

```swift
public protocol JSONDecodable {
  typealias DecodedType = Self
  class func decode(JSONValue) -> DecodedType?
}
```

You will need to implement the `decode` function to perform any kinds of
transformations you need to transform your model from a JSON value. A simple
implementation for an enum value might look like:

```swift
enum RoleType: String {
  case Admin = "Admin"
  case User = "User"
}

extension RoleType: JSONDecodable {
  static func decode(j: JSONValue) -> RoleType? {
    switch j {
    case let .JSONString(s): return RoleType(rawValue: s)
    default: return .None
    }
  }
}
```

The real power of Argo can be seen when decoding actual model objects. To
illustrate this, we will decode the simple `User` object that we used earlier.

Create your model normally:

```swift
struct User {
  let id: Int
  let name: String
}
```

You will also want to create a curried creation function. This is needed
because of a deficiency in Swift that doesn't allow us to pass `init`
functions around like other functions.

```swift
extension User {
  static func create(id: Int)(name: String) -> User {
    return User(id: id, name: name)
  }
}
```

Using this curried syntax will allow us to partially apply the function over
the course of the decoding process. If you'd like to learn more about
currying, we recommend the following articles:

- [Apple's documentation of curried functions](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Declarations.html#//apple_ref/doc/uid/TP40014097-CH34-XID_615)
- [Introduction to Function Currying in Swift](http://robots.thoughtbot.com/introduction-to-function-currying-in-swift)

The last thing to do will be to conform to `JSONDecodable` and implement the
required `decode` function. We will implement this function by using `map`
(`<^>`) and `apply` (`<*>`) to conditionally pass the required parameters to
the creation function. The common pattern will look like:

```swift
return Model.create <^> paramOne <*> paramTwo <*> paramThree
```

and so on. If any of those parameters are `.None`, the entire creation process
will fail, and the function will return `.None`. If all of the parameters are
`.Some(value)`, the value will be unwrapped and passed to the creation
function.

In order to help with the decoding process, Argo introduces two new operators
for parsing a value out of the JSON:

- `<|` will attempt to parse a single value from the JSON
- `<||` will attempt to parse an array of values from the JSON

The usage of these operators is the same regardless:

- `json <| "key"` is analogous to `json["key"]`
- `json <| ["key", "nested"]` is analogous to `json["key"]["nested"]`

Both operators will attempt to parse the value from the JSON and will also
attempt to cast the value to the expected type. If it can't find a value, or
if that value is of the wrong type, the function will return `.None`.

There are also Optional versions of these operators:

- `<|?` will attempt to parse an optional value from the JSON
- `<||?` will attempt to parse an optional array of values from the JSON

Usage is the same as the non-optionals. The difference is that if these fail
parsing, the parsing continues. This is useful for including parameters that
truly are optional values. For example, if your system doesn't require someone
to supply an email address, you could have an optional property: `let email:
String?` and parse it with `json <|? "email"`.

So to implement our `decode` function, we can use the JSON parsing operator in
conjunction with `map` and `apply`:

```swift
extension User: JSONDecodable {
  static func decode(j: JSONValue) -> User? {
    return User.create
      <^> j <| "id"
      <*> j <| "name"
  }
}
```

For comparison, this same function without Argo would look like so:

```swift
extension User {
  static func decode(j: NSDictionary) -> User? {
    if let id = j["id"] as Int {
      if let name = j["name"] as String {
        return User(id: id, name: name)
      }
    }

    return .None
  }
}
```

You could see how this would get much worse with a more complex model.

You can decode custom types the same way, as long as the type also conforms to
`JSONDecodable`.

For more examples on how to use Argo, please check out the tests.
