Argo
====

The Greek word for _swift_ and the ship used by Jason, son of Aeson, of the
Argonauts. Aeson is the JSON parsing library in Haskell that inspired Argo,
much like Aeson inspired his son Jason.

## Installation

Until CocoaPods fully supports Swift projects, my recommended method of
installation is to use git-submodules. Add this repo as a submodule to your
project repo, then add the project file to you workspace.

## Usage

First, create your model. I like to use structs but a class is OK too.

```swift
struct User {
  let id: Int
  let name: String
  let email: String?
}
```

Then, extend the model to conform to `JSONDecodable`. You will also need to
write a static constructor method that is curried. I like to use `create`.

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
JSON. If incoming JSON looks like this:

```
{
  "id": 1,
  "name": "Cool User",
  "email": "cool.user@example.com"
}
```

Then the decoding implementation will look like this:

```swift
extension User: JSONDecodable {
  static func create(id: Int)(name: String)(email: String?) -> User {
    return User(id: id, name: name, email: email)
  }

  static func decode(json: JSON) -> User? {
    return _JSONParse(json) >>- { d in
      User.create
        <^> d <|  "id"
        <*> d <|  "name"
        <*> d <|* "email"
    }
  }
}
```

First, we check that `json` is a JSON object using `_JSONParse`. Then, we bind
(`>>-`) that to a closure that takes our JSON object and returns the optional
`User`. We call `User.create` and use fmap (`<^>`) and apply (`<*>`) to check
if each value exists within the JSON object. If any value is missing, the
operation will return `.None`; otherwise, we'll receive the `User`. `d` is our
JSON object and we pull the value from it by using the `<|` (`<|*` for
optionals) operator along with the key that references the value we want. It's
important that these values follow the same order as the `create` function
parameters.

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

  static func decode(json: JSON) -> Post? {
    return _JSONParse(json) >>- { d in
      Post.create
        <^> d <| "id"
        <*> d <| "text"
        <*> d <| "author"
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

You can pull values from embedded objects by chaining `<|`. This `Post` model
just stores the author's name and not the whole model.

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

  static func decode(json: JSON) -> Post? {
    return _JSONParse(json) >>- { d in
      Post.create
        <^> d <| "id"
        <*> d <| "text"
        <*> d <| "author" <| "name"
    }
  }
}
```

Arrays of models or Swift types also work the same way.

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

  static func decode(json: JSON) -> Post? {
    return _JSONParse(json) >>- { d in
      Post.create
        <^> d <| "id"
        <*> d <| "text"
        <*> d <| "author" <| "name"
        <*> d <| "comments"
    }
  }
}
```

`Post` comments could also be an array of a custom struct `Comment` in that
example and the decoding code would still be the same as long as `Comment` also
conforms to `JSONDecodable`.
