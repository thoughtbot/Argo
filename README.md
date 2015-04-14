<img src="https://raw.githubusercontent.com/thoughtbot/Argo/gh-pages/Argo.png" width="250" />

# Argo [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

The Greek word for _swift_ and the ship used by Jason, son of Aeson, of the
Argonauts. Aeson is the JSON parsing library in Haskell that inspired Argo,
much like Aeson inspired his son Jason.

NOTE: For Swift 1.1 support, use the versions tagged 0.3.x, which you can read
about in the [releases].

[releases]: https://github.com/thoughtbot/Argo/releases

## Installation

### [Carthage]

[Carthage]: https://github.com/Carthage/Carthage

Add the following to your Cartfile:

```
github "thoughtbot/Argo"
```

Then run `carthage update`.

Follow the current instructions in [Carthage's README][carthage-installation]
for up to date installation instructions.

[carthage-installation]: https://github.com/Carthage/Carthage#adding-frameworks-to-an-application

You'll also need to add `Runes.framework` and `Box.framework` to your Xcode
project.

[Runes]: https://github.com/thoughtbot/runes
[Box]: https://github.com/robrix/box

### [CocoaPods]

[CocoaPods]: http://cocoapods.org

Add the following to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html):

```ruby
pod 'Argo'
```

You will also need to make sure you're opting into using frameworks:

```ruby
use_frameworks!
```

Then run `pod install` with CocoaPods 0.36 or newer.

### Git Submodules

I guess you could do it this way if that's your thing.

Add this repo as a submodule, and add the project file to your workspace. You
can then link against `Argo.framework` for your application target.

You'll also need to add [Runes] and [Box] to your project the same way.

## Usage tl;dr:

```swift
import Argo
import Runes

struct User {
  let id: Int
  let name: String
  let email: String?
  let role: Role
  let companyName: String
  let friends: [User]
}

extension User: Decodable {
  static func create(id: Int)(name: String)(email: String?)(role: Role)(companyName: String)(friends: [User]) -> User {
    return User(id: id, name: name, email: email, role: role, companyName: companyName, friends: friends)
  }

  static func decode(j: JSON) -> Decoded<User> {
    return User.create
      <^> j <| "id"
      <*> j <| "name"
      <*> j <|? "email" // Use ? for parsing optional values
      <*> j <| "role" // Custom types that also conform to Decodable just work
      <*> j <| ["company", "name"] // Parse nested objects
      <*> j <|| "friends" // parse arrays of objects
  }
}

// Wherever you receive JSON data:

let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: .None)

if let j: AnyObject = json {
  let user: User? = decode(j)
}
```

## Ideology

Argo's core concept is that in order to maintain type safety, you should only
be able to successfully decode an object if all parameters are satisfied
properly. So if you have a model that looks like this:

```swift
struct User {
  let id: Int
  let name: String
}
```

but the JSON you receive from the server looks like this:

```json
{
  "user": {
    "id": "this isn't a number",
    "name": "Gob Bluth"
  }
}
```

then ideally, JSON parsing would fail, and you'd get an error state instead of
a `User` object. In Argo, if JSON parsing succeeds you'll recieve the `User`
object and you can be sure that it is full and valid. If it fails, you will
instead be given the reason why the `User` couldn't be constructed.

If you're interested in learning more about the concepts and ideology that
went into building Argo, we recommend reading the series of articles that were
written alongside its development:

- [Efficient JSON in Swift with Functional Concepts and Generics](http://robots.thoughtbot.com/efficient-json-in-swift-with-functional-concepts-and-generics)
- [Real World JSON Parsing with Swift](http://robots.thoughtbot.com/real-world-json-parsing-with-swift)
- [Parsing Embedded JSON and Arrays in Swift](http://robots.thoughtbot.com/parsing-embedded-json-and-arrays-in-swift)

## Functional Concepts

Argo really wants to be used with patterns borrowed from functional
programming such as `map` and `apply`. We feel that these patterns greatly
reduce the pain felt in trying to use JSON (an inherently loosely typed
format) with Swift (a strictly typed language). It also gives us a way to
succinctly maintain the core concept described above, and short circuit the
decoding process if any part of it fails.

Additionally, we feel that the use of operators for these functions greatly
improves the readability of the code we're suggesting. Using named functions
would lead to nested functions and a confusing number of parenthesis.

If you aren't familiar with how these functions work (or just aren't
comfortable with using operators), that's totally OK. It's possible to use the
library without using them, although it might be a little more painful.

If you're looking to learn more about these functions, we would recommend
reading the following articles:

- [Functional Swift for Dealing with Optional Values](http://robots.thoughtbot.com/functional-swift-for-dealing-with-optional-values)
- [Railway Oriented Programming](http://fsharpforfunandprofit.com/posts/recipe-part2/)

And check out this talk:

- [How I Learned To Stop Worrying And Love The Functor](https://github.com/gfontenot/talks/tree/master/Functors)

## Usage

The first thing you need to do when you receive JSON data is convert it from
`NSData` to an `AnyObject` using the built-in `NSJSONSerialization` API. Once
you have the `AnyObject`, you can call the global `decode` function to get back
the decoded model.

```swift
var error: NSError?
let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions(0), error: &error)

if let j: AnyObject = json {
  let user: User? = decode(j) // ignore error info or
  let decodedUser: Decoded<User> = decode(j) // preserve error info
} else {
  // handle error
}
```

Note that you probably want to use an error pointer to track errors from
`NSJSONSerialization`.

The `JSON` enum exists to help with some of the type inference, and also wraps
up some of the casting that you'll need to do to transform the JSON into native
types.

Argo 1.0 introduces a new type: `Decoded<T>`. This is now the type returned
from the `decode` function that you implement as part of the `Decodable`
protocol. This new type allows you to preserve information about why a decoding
failed. You can choose to either ignore the `Decoded` type and just get back
the optional value or keep the `Decoded` type and use it to debug decoding
errors. When you decode an `AnyObject` into a model using the global `decode`
function, you can specify whether you want an `Optional` model or a `Decoded`
model by specifying the return type as seen in the code block above.

Next, you need to make sure that models that you wish to decode from JSON
conform to the `Decodable` protocol:

```swift
public protocol Decodable {
  typealias DecodedType = Self
  class func decode(JSON) -> Decoded<DecodedType>
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

extension RoleType: Decodable {
  static func decode(j: JSON) -> Decoded<RoleType> {
    switch j {
    case let .String(s): return .fromOptional(RoleType(rawValue: s))
    default: return .TypeMismatch("\(j) is not a String") // Provide an Error message for a string type mismatch
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

The last thing to do will be to conform to `Decodable` and implement the
required `decode` function. We will implement this function by using `map`
(`<^>`) and `apply` (`<*>`) to conditionally pass the required parameters to
the curried creation function. The common pattern will look like:

```swift
return Model.create <^> paramOne <*> paramTwo <*> paramThree
```

and so on. If any of those parameters are an error, the entire creation process
will fail, and the function will return the first error. If all of the
parameters are successful, the value will be unwrapped and passed to the
`create` function.

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
to supply an email address, you could have an optional property: `let email:
String?` and parse it with `json <|? "email"`.

So to implement our `decode` function, we can use the JSON parsing operator in
conjunction with `map` and `apply`:

```swift
extension User: Decodable {
  static func decode(j: JSON) -> Decoded<User> {
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
`Decodable`.

For more examples on how to use Argo, please check out the tests.

Contributing
------------

See the [CONTRIBUTING] document. Thank you, [contributors]!

[CONTRIBUTING]: CONTRIBUTING.md
[contributors]: https://github.com/thoughtbot/Argo/graphs/contributors

Need Help?
----------

We offer 1-on-1 coaching. We can help you with functional programming in Swift,
get started writing unit tests, and convert from Objective-C to Swift.
[Get in touch].

[Get in touch]: http://coaching.thoughtbot.com/ios/?utm_source=github

License
-------

Argo is Copyright (c) 2015 thoughtbot, inc. It is free software, and may be
redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: /LICENSE

About
-----

![thoughtbot](https://thoughtbot.com/logo.png)

Argo is maintained and funded by thoughtbot, inc. The names and logos for
thoughtbot are trademarks of thoughtbot, inc.

We love open source software! See [our other projects][community] or look at
our product [case studies] and [hire us][hire] to help build your iOS app.

[community]: https://thoughtbot.com/community?utm_source=github
[case studies]: https://thoughtbot.com/ios?utm_source=github
[hire]: https://thoughtbot.com/hire-us?utm_source=github
