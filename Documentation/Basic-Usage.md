## Usage

The first thing you need to do when you receive JSON data is convert it from
`NSData` to an `AnyObject` using `Foundation`'s `NSJSONSerialization` API.
Once you have the `AnyObject`, you can call the global `decode` function to get
back the decoded model.

```swift
let json: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(responseData, options: [])

if let j: AnyObject = json {
  let user: User? = decode(j) // ignore error info or
  let decodedUser: Decoded<User> = decode(j) // preserve error info
}
```

Argo 1.0 introduces a new type: `Decoded<T>`. This is the type returned from
the `decode` function that you implement as part of the `Decodable` protocol.
This new type allows you to preserve information about why a decoding failed.
You can choose to either ignore the `Decoded` type and just get back the
optional value or keep the `Decoded` type and use it to debug decoding errors.
When you decode an `AnyObject` into a model using the global `decode` function,
you can specify whether you want an `Optional` model or a `Decoded` model by
specifying the return type as seen in the code block above.

Next, you need to make sure that models that you wish to decode from JSON
conform to the `Decodable` protocol:

```swift
public protocol Decodable {
  typealias DecodedType = Self
  class func decode(JSON) -> Decoded<DecodedType>
}
```

You will need to implement the `decode` function to perform any kinds of
transformations you need to transform your model from a JSON value. The power
of Argo can be seen when decoding actual model objects. To illustrate this, we
will decode the simple `User` object.

Create your `User` model:

```swift
struct User {
  let id: Int
  let name: String
}
```

We will be using [`Curry`] to help with decoding our `User` model. Currying
allows us to partially apply the `init` function over the course of the
decoding process. If you'd like to learn more about currying, we recommend the
following articles:

[`Curry`]: https://github.com/thoughtbot/Curry

- [Apple's documentation of curried functions](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Declarations.html#//apple_ref/doc/uid/TP40014097-CH34-XID_615)
- [Introduction to Function Currying in Swift](http://robots.thoughtbot.com/introduction-to-function-currying-in-swift)

Now, we make `User` conform to `Decodable` and implement the required `decode`
function. We will implement this function by using `map` (`<^>`) and `apply`
(`<*>`) to conditionally pass the required parameters to the curried init
function. The common pattern will look like:

```swift
return curry(Model.init) <^> paramOne <*> paramTwo <*> paramThree
```

and so on. If any of those parameters are an error, the entire creation process
will fail, and the function will return the first error. If all of the
parameters are successful, the value will be unwrapped and passed to the
`init` function.

In order to help with the decoding process, Argo introduces two new operators
for parsing a value out of the JSON:

- `<|` will attempt to parse a single value from the JSON
- `<||` will attempt to parse an array of values from the JSON

The usage of these operators is the same regardless:

- `json <| "key"` is analogous to `json["key"]`
- `json <| ["key", "nested"]` is analogous to `json["key"]["nested"]`

Both operators will attempt to parse the value from the JSON and will also
attempt to cast the value to the expected type. If it can't find a value, the
function will return a `Decoded.MissingKey(message: String)` error. If the
value it finds is the wrong type, the function will return a
`Decoded.TypeMismatch(message: String)` error.

There are also Optional versions of these operators:

- `<|?` will attempt to parse an optional value from the JSON
- `<||?` will attempt to parse an optional array of values from the JSON

Usage is the same as the non-optionals. The difference is that if these fail
parsing, the parsing continues. This is useful for including parameters that
truly are optional values. For example, if your system doesn't require someone
to supply an email address, you could have an optional property on `User`: `let
email: String?` and parse it with `json <|? "email"`.

So to implement our `decode` function, we can use the JSON parsing operator in
conjunction with `map` and `apply`:

```swift
extension User: Decodable {
  static func decode(j: JSON) -> Decoded<User> {
    return curry(User.init)
      <^> j <| "id"
      <*> j <| "name"
  }
}
```

For comparison, this same function without Argo would look like so:

```swift
extension User {
  static func decode(j: NSDictionary) -> User? {
    if let id = j["id"] as Int,
       let name = j["name"] as String
    {
      return User(id: id, name: name)
    }

    return .None
  }
}
```

You could see how this would get much worse with a more complex model.

You can decode custom types the same way, as long as the type also conforms to
`Decodable`. This is how we implement [relationships].

[relationships]: Relationships.md

