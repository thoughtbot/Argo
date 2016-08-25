## Usage

Argo uses Swift's type system along with concepts from functional programming to
let you smoothly transform JSON data into Swift model types. Argo does this with
a minimum of syntax, while at the same time improving type safety and data
integrity compared to other approaches.

You may need to learn a few things in order to learn Argo effectively, but once
you do so, you'll have a powerful new tool to hang on your belt!

### Decoding basics

Argo's whole purpose is to let you easily pick apart structured data (normally
in the form of a dictionary created from JSON data) and create Swift objects
based on the decoded content. Typically, you'll want to do this with JSON data
received from a server or elsewhere. The first thing you need to do is convert
the JSON data from `NSData` to an `Any` using `Foundation`'s
`NSJSONSerialization` API.  Once you have the `Any`, you can call Argo's
global `decode` function to get back the decoded model.

```swift
let json: Any? = try? NSJSONSerialization.JSONObjectWithData(responseData, options: [])

if let j: Any = json {
  let user: User? = decode(j)                  // ignore failure info or
  let decodedUser: Decoded<User> = decode(j)   // preserve failure info
}
```

As you see in this example, Argo introduces a new type: `Decoded<T>`.  This new
type contains either a successfully decoded object or a failure state that
preserves information about why a decoding failed. You can choose to either
ignore the `Decoded` type and just get back the optional value or keep the
`Decoded` type and use it to debug or report decoding failures.  When you decode
an `Any` into a model using the global `decode` function, you can specify
whether you want an `Optional` model or a `Decoded` model by specifying the
return type as seen in the code block above.

### Implementing `Decodable`

In order for this to work with your own model types, you need to make sure that
models that you wish to decode from JSON conform to the `Decodable` protocol:

```swift
public protocol Decodable {
  typealias DecodedType = Self
  static func decode(json: JSON) -> Decoded<DecodedType>
}
```

In your model, you need to implement the `decode` function to perform whatever
transformations are needed in order to create your model from the given JSON
structure.  To illustrate this, we will decode a simple model type called
`User`. Start by creating this `User` model:

```swift
struct User {
  let id: Int
  let name: String
}
```

### Currying `User.init`

We will be using another small library called [`Curry`] to help with decoding
our `User` model. Currying allows us to partially apply the `init` function over
the course of the decoding process. This basically means that we can build up
the `init` function call bit by bit, adding one parameter at a time, if and only
if Argo can successfully decode them. If any of the parameters don't meet our
expectations, Argo will skip the `init` call and return a special failure state. 

[`Curry`]: https://github.com/thoughtbot/Curry

> If you'd like to learn more about currying, we recommend the following articles:
> 
> 
> - [Apple's documentation of curried functions](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Declarations.html#//apple_ref/doc/uid/TP40014097-CH34-XID_615)
> - [Introduction to Function Currying in Swift](http://robots.thoughtbot.com/introduction-to-function-currying-in-swift)

Now, we make `User` conform to `Decodable` and implement the required `decode`
function. We will implement this function by using some [functional
concepts](Functional-Concepts.md),
specifically the `map` (`<^>`) and `apply` (`<*>`) operators, to conditionally
pass the required parameters to the curried init function. The common pattern
will look like this:


```swift
  static func decode(json: JSON) -> Decoded<DecodedType> {
    return curry(Model.init) <^> paramOne <*> paramTwo <*> paramThree
  }
```

and so on. If any of those parameters are a failure state, then the entire
creation process will fail, and the function will return the first failure
state. If all of the parameters are successful, the value will be unwrapped and
passed to the `init` function.

### Safely pulling values from JSON

In the example above, we showed some non-existent parameters (`paramOne`, etc), but
one of Argo's main features is the ability to help you grab the real parameters
from the JSON structure in a way that is type-safe and concise. You don't need
to manually check to make sure that a value is non-nil, or that it's of the
right type. Argo leverages Swift's expressive type system to do that heavy
lifting for you. To help with the decoding process, Argo introduces two new
operators for parsing a value out of the JSON:

- `<|` will attempt to parse a single value from the JSON
- `<||` will attempt to parse an array of values from the JSON

These are infix operators that correspond to familiar operations:

- `json <| "name"` is analogous to `json["name"]`, in cases where a single item
  is associated with the `"name"` key
- `json <|| "posts"` is analogous to `json["posts"]`, in cases where an array of
  items is associated with the `"posts"` key

As a bonus, if your JSON contains nested data whose elements are also
`Decodable`, then you can retrieve a nested value by using an array of strings:

- `json <| ["location", "city"]` is analogous to `json["location"]["city"]`

Each of these operators will attempt to extract the specified value from the
JSON structure. If a value is found, the operator will then attempt to cast the
value to the expected type. If that all works out, the operator will return the
decoded object wrapped inside a `Decoded<T>.Success(.Some(value))`. If the value
it finds is of the wrong type, the function will return a
`Decoded<T>.Failure(.TypeMismatch(expected: String, actual: String))` failure state. If
it can't find any value at all for the specified key, the function will return a
`Decoded<T>.Failure(.MissingKey(name: String))` failure state. 

There are also Optional versions of these operators:

- `<|?` will attempt to parse an optional value from the JSON
- `<||?` will attempt to parse an optional array of values from the JSON

Usage is the same as for the non-optional variants. The difference is that if
these operators happen to pull a `nil` value from the JSON, they will consider
this a success and continue on, rather than returning a failure state.  This is
useful for including parameters that truly are optional values. For example, if
your system doesn't require someone to supply an email address, you could have
an optional property on `User` such as `let email: String?` and use `json <|?
"email"` to decode either an email string or a `nil` value.

### Finally implementing your `decode` function

So, to implement our `decode` function, we can use the JSON parsing operator in
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

For comparison, an implementation of a similar function without Argo could look
like this:

```swift
extension User {
  static func decode(j: NSDictionary) -> User? {
    if let id = j["id"] as? Int,
       let name = j["name"] as? String
    {
      return User(id: id, name: name)
    }

    return .None
  }
}
```

Not only is that code much more verbose than the equivalent code using Argo, it
also doesn't return to the caller any indication of where or why any failures
occur. This technique also requires you to specify the type of
each value in multiple places, which means that if the type of one of your
values changes, you'll have to change it at multiple places in your code. If
you're using Argo, however, you just need to declare the types of your
properties in your model, and then the Swift compiler will infer the types that
need to be sent to the curried `decode` function and therefore the types that
need to be found in the JSON structure.

You can decode custom types the same way, as long as the type also conforms to
`Decodable`. This is how we implement [relationships].

[relationships]: Relationships.md

For more Argo usage examples, see our [test suite](../ArgoTests).
