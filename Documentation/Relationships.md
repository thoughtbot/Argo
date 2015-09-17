# Decoding Relationships

It's very common to have models that relate to other models. When all your
models conform to `Decodable`, Argo makes it really easy to populate those
relationships. "How does this work?", you ask. Well, Argo is smart enough to
know it can decode anything that conforms to `Decodable` because internally,
Argo is simply calling each type's `decode` function. That means that any type
that conforms to `Decodable` looks the same to Argo as a `String` or `Int`; in
fact, Argo can only decode those Swift types because we've already implemented
`Decodable` for them.

Let's look at a `User`, `Post`, and `Comment` model and how they relate. First,
our server is sending us the JSON for the `Post` model:

```
{
  "author": {
    "id": 6,
    "name": "Gob Bluth"
  },
  "text": "I've made a huge mistake."
}
```

Our `Post` model could then be:

```swift
struct Post {
  let author: String
  let text: String
}
```

For now, we only need the user's name and we can use the special embedded syntax
to get it. Then our implementation of `Decodable` for `Post` looks
like this:

```swift
extension Post: Decodable {
  static func decode(j: JSON) -> Decoded<Post> {
    return curry(self.init)
      <^> j <| ["author", "name"]
      <*> j <| "text"
  }
}
```

Great! Now we can decode JSON into `Post` models. However, let's be real, we
can't have posts without comments! Comments are like 90% of the fun on the
internet.

Most likely the JSON will contain an embedded array of `Comment` models:

```
{
  "author": {
    "id": 53,
    "name": "Lindsay"
  },
  "text": "I have the afternoon free.",
  "comments": [
    {
      "author": {
        "id": 1,
        "name": "Lucille"
      },
      "text": "Really? Did 'nothing' cancel?"
    }
  ]
}
```

So then `Comment` will look like:

```swift
struct Comment {
  let author: String
  let text: String
}

extension Comment: Decodable {
  static func decode(j: JSON) -> Decoded<Comment> {
    return curry(self.init)
      <^> j <| ["author", "name"]
      <*> j <| "text"
  }
}
```

Now, we can add an array of comments to our `Post` model:

```swift
struct Post {
  let author: String
  let text: String
  let comments: [Comment]
}

extension Post: Decodable {
  static func decode(j: JSON) -> Decoded<Post> {
    return curry(self.init)
      <^> j <| ["author", "name"]
      <*> j <| "text"
      <*> j <|| "comments"
  }
}
```

We added `comments` as a property on our `Post` model. Then we added a line to
decode the comments from the JSON. Notice how we use `<||` instead of `<|` with
`comments` because it is an _Array_.

Storing the name of the author with a post or comment isn't very flexible.
What we really want to do is tie posts and comments to users. If we use the
`User` struct from [Basic Usage]:

[Basic Usage]: Basic-Usage.md

```swift
struct User {
  let id: Int
  let name: String
}

extension User: Decodable {
  static func decode(j: JSON) -> Decoded<User> {
    return curry(User.init)
      <^> j <| "id"
      <*> j <| "name"
  }
}
```

We can simply change the `author` property from `String` to `User` and point the
decoder directly at the author object. No joke! Take a look:

```swift
struct Post {
  let author: User
  let text: String
  let comments: [Comment]
}

extension Post: Decodable {
  static func decode(j: JSON) -> Decoded<Post> {
    return curry(self.init)
      <^> j <| "author"
      <*> j <| "text"
      <*> j <|| "comments"
  }
}

struct Comment {
  let author: User
  let text: String
}

extension Comment: Decodable {
  static func decode(j: JSON) -> Decoded<Comment> {
    return curry(self.init)
      <^> j <| "author"
      <*> j <| "text"
  }
}
```

That's it! Argo's use of Generics and the `Decodable` protocol means that
supporting custom types is straightforward, since that's internally the same way
Argo decodes Swift's standard types.
