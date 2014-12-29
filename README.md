Argo
====

The Greek word for _swift_ and the ship used by Jason, son of Aeson, of the
Argonauts. Aeson is the JSON parsing library in Haskell that inspired Argo,
much like Aeson inspired his son Jason.

## Installation

### [Carthage]

[Carthage]: https://github.com/Carthage/Carthage

Add the following to your Cartfile:

```
github "thoughtbot/Argo"
```

Then run `carthage update`. Drag `Argo.framework` into your project, and
you're good to go.

### [CocoaPods]

[CocoaPods]: http://cocoapods.org

 *coming soon*

### Git Submodules ###

I guess you could do it this way if that's your thing.

Add this repo as a submodule, and add the project file to your workspace. You
can then link against `Argo.framework` for your application target.

## Usage

First, create your model. We like to use structs but a class is OK too.

```swift
struct User {
  let id: Int
  let name: String
  let email: String?
}
```

Then, extend the model to conform to `JSONDecodable`. You will also need to
write a static constructor method that is curried. We like to use `create`.

```swift
extension User: JSONDecodable {
  static func create(id: Int)(name: String)(email: String?) -> User {
    return User(id: id, name: name, email: email)
  }
}
```

It's important that the `create` function's parameters are all in separate
parenthesis. This will make the function curried. Then inside the function we
can call the model's constructor.

Finally, implement the `JSONDecodable` `decode` function to decode the incoming
JSON. Here is an example of decoding a `User` from JSON received from a network
request.

JSON received from network request:
```
{
  "id": 1,
  "name": "Cool User",
  "email": "cool.user@example.com"
}
```

Parse data to JSON then to a `JSONValue` and finally to our `User` object:

```swift
let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions(0), error: nil)

if let j: AnyObject = json {
  if let value: JSONValue = JSONValue.parse(j) {
    let user: User? = User.decode(value)
  }
}
```

1. We use `NSJSONSerialization` to get a JSON object from the data.
2. Then we unwrap the JSON into `JSONValue`s `parse` function to give us our
   `JSONValue` object.
3. Now we can unwrap the `JSONValue` object into the `User` `decode` function
   to get our `User` object.

Then the decoding implementation will look like this:

```swift
extension User: JSONDecodable {
  static func create(id: Int)(name: String)(email: String?) -> User {
    return User(id: id, name: name, email: email)
  }

  static func decode(j: JSONValue) -> User? {
    return User.create
      <^> j <|  "id"
      <*> j <|  "name"
      <*> j <|? "email"
    }
  }
}
```

We create the user by calling `User.create` and use fmap (`<^>`) and apply
(`<*>`) to check if each value exists within the `JSONValue` object. If any
value is missing, the operation will return `.None`; otherwise, we'll receive
the `User`. `j` is our `JSONValue` object and we pull values from it by using
the `<|` operator (`<|?` for optionals) along with the key that references the
value we want. It's important that these values follow the same order as the
`create` function parameters.

## Advanced

As long as your models conform to `JSONDecodable` you can use them in other
models like this `Post` model.

```swift
struct Post {
  let id: Int
  let text: String
  let author: User
}

extension Post: JSONDecodable {
  static func create(id: Int)(text: String)(author: User) -> Post {
    return Post(id: id, text: text, author: author)
  }

  static func decode(j: JSONValue) -> Post? {
    return Post.create
      <^> j <| "id"
      <*> j <| "text"
      <*> j <| "author"
    }
  }
}
```

From the JSON:

```
{
  "id": 5,
  "text": "A cool story.",
  "author": {
    "id": 1,
    "name": "Cool User"
  }
}
```

You can pull values from embedded objects by passing an array of keys as
`Strings` to `<|`. For example, this `Post` model just stores the author's name
and not the whole model.

```swift
struct Post {
  let id: Int
  let text: String
  let authorName: String
}

extension Post: JSONDecodable {
  static func create(id: Int)(text: String)(authorName: String) -> Post {
    return Post(id: id, text: text, authorName: authorName)
  }

  static func decode(j: JSONValue) -> Post? {
    return Post.create
      <^> j <| "id"
      <*> j <| "text"
      <*> j <| ["author", "name"]
    }
  }
}
```

Arrays of models or Swift types also work the same way; however, we have a
slightly modified operator to distinguish between values and arrays of values,
`<||` and `<||?` for optional arrays.

```swift
struct Post {
  let id: Int
  let text: String
  let authorName: String
  let comments: [String]
}

extension Post: JSONDecodable {
  static func create(id: Int)(text: String)(authorName: String)(comments: [String]) -> Post {
    return Post(id: id, text: text, authorName: authorName, comments: comments)
  }

  static func decode(j: JSONValue) -> Post? {
    return Post.create
      <^> j <|  "id"
      <*> j <|  "text"
      <*> j <|  ["author", "name"]
      <*> j <|| "comments"
    }
  }
}
```

`Post` comments could also be an array of a custom struct `Comment` in that
example and the decoding code would still be the same as long as `Comment` also
conforms to `JSONDecodable`.

For more examples on how to use Argo, please check out the tests.
