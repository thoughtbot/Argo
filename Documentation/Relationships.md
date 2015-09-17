It's very common to have custom models that relate to other custom models.
When all your models conform to `Decodable`, Argo makes it really easy to
populate those relationships. Let's look at a `Post` and `Comment` model and
how they relate.

Our `Post` model will be very simple:

```swift
struct Post {
  let author: String
  let text: String
}
```

Then, implementing `Decodable` for `Post` we get this:

```swift
extension Post: Decodable {
  static func decode(j: JSON) -> Decoded<Post> {
    return curry(self.init)
      <^> j <| "author"
      <*> j <| "text"
  }
}
```

And the json looks like this:

```
{
  "author": "Gob Bluth",
  "text": "I've made a huge mistake.."
}
```

Great! Now we can decode json into `Post` models. Let's be real, we can't have
posts without comments! Comments are like 90% of the fun on the internet. (See
reddit, YouTube, etc)

Let's look at a simple `Comment` model:

```swift
struct Comment {
  let author: String
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
      <^> j <| "author"
      <*> j <| "text"
      <*> j <|| "comments"
  }
}
```

We added the array as a property on out `Post` model. Then we added a line to
decode the comments array from the json. We use `<||` because it is an _Array_.

With the embedded comments array, the json may look like this:

```
{
  "author": "Lindsay",
  "text": "I have the afternoon free.",
  "comments": [
    {
      "author": "Lucille",
      "text": "Really? Did \"nothing\" cancel?"
    }
  ]
}
```

Next, let's say the author's name isn't good enough and we want the `User`
relationship to the `Post` and `Comment`. If you use the `User` code from
[Basic Usage], we can simply replace the `String` type with `User` on the
`author` property of out models.

[Basic Usage]: Basic-Usage.md

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

Where the json now has an embedded `User`:

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
      "text": "Really? Did \"nothing\" cancel?"
    }
  ]
}
```

Yep that's right, the only thing that changed was `String` to `User`!

We can also create a convenience property to get directly to the user's name
instead of having to deal with the model later.

```swift
struct Post {
  let author: User
  let authorName: String
  let text: String
  let comments: [Comment]
}

extension Post: Decodable {
  static func decode(j: JSON) -> Decoded<Post> {
    return curry(self.init)
      <^> j <| "author"
      <*> j <| ["author", "name"]
      <*> j <| "text"
      <*> j <|| "comments"
  }
}

struct Comment {
  let author: User
  let authorName: String
  let text: String
}

extension Comment: Decodable {
  static func decode(j: JSON) -> Decoded<Comment> {
    return curry(self.init)
      <^> j <| "author"
      <*> j <| ["author", "name"]
      <*> j <| "text"
  }
}
```

Using an array of strings allows us to traverse embedded objects to get at the
value we want.

