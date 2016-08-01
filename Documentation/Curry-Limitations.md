# `curry` limitations

It is very important to fully curry your model’s `init` in order to use Argo.
Because of this, Our recommended best practice is to use [Curry] which allows
you to change your standard `init` functions into fully curried functions.
Unfortunately, The Swift compiler can currently only handle compiling `curry`
for around 20 arguments in a reasonable amount of time. That may sound like a
lot, but one can still run up against this limitation quite quickly,
especially when you are not in control of the JSON API you are interfacing
with.

[Curry]: https://github.com/thoughtbot/Curry

The solution is to try to find a way to normalize your data into nested models,
thus reducing the number of arguments needed for `init`. For simplicity, assume
for a moment that `curry` was only defined for functions of 5 arguments or less,
and consider the following model:

```swift
struct User: Decodable {
  let id: Int
  let name: String
  let bio: String
  let smallAvatar: String
  let mediumAvatar: String
  let largeAvatar: String

  static func decode(j: JSON) -> Decoded<User> {
    return curry(User.init)
      <^> j <| "id"
      <*> j <| "name"
      <*> j <| "bio"
      <*> j <| "small_avatar"
      <*> j <| "medium_avatar"
      <*> j <| "large_avatar"
  }
}
```

With our assumption on `curry`, we would get a Swift compiler error when doing
`curry(User.init)` because `User.init` takes 6 arguments. Even though the API
has decided to send back separate fields for each avatar size, we can
normalize this response by introducing a new `Avatar` type.

```swift
struct User {
  let id: Int
  let name: String
  let bio: String
  let avatar: Avatar
}

struct Avatar {
  let small: String
  let medium: String
  let large: String
}
```

Now `User.init` has 4 arguments and `Avatar.init` has 3 arguments, so we are
within the assumed limitations of `curry`. But, it is also less clear how we
should write `User.decode`. How can we extract the 3 avatar fields from `JSON`
to build `Avatar` first, and then use that to build `User`? The key insight is
to see that `j <| "key"` returns a `Decoded<T>` value, representing one step
of decoding. So, we can decode a `Avatar` first using `j`, and then plug that
directly into `curry(User.init)`:

```swift
extension Avatar: Decodable {
  static func decode(j: JSON) -> Decoded<Avatar> {
    return curry(Avatar.init)
      <^> j <| "small_avatar"
      <*> j <| "medium_avatar"
      <*> j <| "large_avatar"
  }
}

extension User: Decodable {
  static func decode(j: JSON) -> Decoded<User> {
    return curry(User.init)
      <^> j <| "id"
      <*> j <| "name"
      <*> j <| "bio"
      <*> Avatar.decode(j)
  }
}
```

We have now successfully gotten around `curry`’s limitations, and also
produced a better, normalized model! We also retain all of the great error
handling that Argo provides, so if there is a decoding error in `Avatar` it
will propagate through to a decoding error in `User`.
