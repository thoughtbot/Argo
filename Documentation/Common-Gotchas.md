# Common Gotchas

There are some common errors that arise when trying to use Argo. Many are due to
the fact that Argo is so fundamentally different from how you might be used to
decoding JSON, and others are due to limitations of Swift. This document aims
to address some of those situations and set you on the right track!

## `curry` limitations

It is very important to fully curry your model’s `init` in order to use Argo.
Because of this, `Argo` recommends using
[`Curry`](https://github.com/thoughtbot/Curry) whichs allows you to change your
standard `init` functions into fully curried functions. Unfortunately, Swift
can only compile `curry` for up to 20 arguments in a reasonable amount of time.
That may sound like a lot, but one can still run up against this limitation
quite quickly, especially when you are not in control of the JSON API you are
interfacing with.

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
has decided to send us back separate fields for each avatar size, there is a
very clear normalization we can do in our model:

```swift
struct User {
  let id: Int
  let name: String
  let bio: String
  let avatar: Avatar

  struct Avatar {
    let small: String
    let medium: String
    let large: String
  }
}
```

Now `User.init` has 4 arguments and `User.Avatar.init` has 3 arguments, so we
are within the assumed limitations of `curry`. But, it is also less clear how we
should write `User.decode`. How can we extract the 3 avatar fields from `JSON`
to build `User.Avatar` first, and then use that to build `User`? The key insight
is to see that `j <| "key"` returns a `Decoded<T>` value, representing one step
of decoding. So, we can decode a `User.Avatar` first using `j`, and then just
plug that directly into `curry(User.init)`:

```swift
extension User.Avatar: Decodable {
  static func decode(j: JSON) -> Decoded<User.Avatar> {
    return curry(User.Avatar.init)
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
      <*> User.Avatar.decode(j)
  }
}
```

We have now successfully gotten around `curry`’s limitations, but also produced
a better, normalized model! We also retain all of the great error handling that
Argo provides, so if there is a decoding error in `User.Avatar` it will
propogate through to a decoding error in `User`.

## Compilation errors

Swift’s compile errors can be mystifying if you are not intimately familiar with
the internals of Argo. Here we describe some of the most common errors and how
to fix them.

### Complex expressions

Considering that the implementation of `decode` on a model consists of fully
currying a method and composing it with many small pieces, each of which may be
the composition of pieces, it is not surprising that Swift sometimes has
difficulty compiling the expression in a reasonable amount of time. This
manifests itself with the following error:

> Expression was too complex to be solved in reasonable time; consider breaking
up the expression into distinct sub-expressions.

Fortunately this is easy to solve. A first step is to simply store
`curry(Model.init)` in a variable instead of using it directly:

```swift
static func decode(j: JSON) -> Decoded<Model> {
  let create = Curry(Model.init)
  return create
    <^> j <| "key1"
    <*> j <| "key2"
    ...
```

Many times this can fix the problem. If you still have complex expression
issues, the next step is to pick a midpoint in your decoding chain and set an
intermediate variable:

```swift
static func decode(j: JSON) -> Decoded<Model> {
  let create = Curry(Model.init)
  let tmp = create
    <^> j <| "key_a_1"
    <*> j <| "key_a_2"
    ...
  return tmp
    <*> j <| "key_b_1"
    <*> j <| "key_b_2"
    ...
```

This should almost surely fix all of your complex expression issues, but if not,
be prepared to try one more intermediate variable. Take careful note that in
defining `tmp` we used the map operator `create <^>` but in the return statement
we used the applicative operator `tmp <*>`. The map operator is _only_ used with
the fully curried `init`.

### Incorrectly decoded fields

When you have not correctly decoded all fields of your model in the `decode`
function you will see an error of the form:

> Cannot invoke 'curry' with an argument list of type 'A -> B -> C'

> Cannot convert value of type 'A -> B -> C' to expected argument type
'_ -> _ -> C'

The latter happens when you are returning `curry(Model.init)` directly, and the
former happens when you have stored `curry(Model.init)` in a variable instead of
returning directly. See the discussion on complex expressions for more
information on why one would do that.

There are a few ways in which you may not have correctly decoded your model:

1. You are missing a `j <| "key"` for a field in your model.
2. You incorrectly decoded the type of a field, e.g. you used
`j <| "optional_key"` when you meant `j <|? "optional_key"`.

The best way forward is to re-examine all of the fields in your model and make
sure they are accounted for in `decode` and that types match up.

### Misuse of functional operators

When you have misused the map `<^>` or applicative `<*>` operators you will see
errors that mention the `Decoded` type. One such kind of error is:

> No 'curry' candidates produce the expected contextual result type
'Decoded<_ -> _ -> _ -> C>'

> Cannot convert value of type 'A -> B -> C' to type 'Decoded<_ -> _ -> C>'

The key difference in these errors from the previous is the mention of
`Decoded<>` on the right side. This most likely means that you are using `<*>`
when you should be using `<^>`:

```swift
static func decode(j: JSON) -> Decoded<Model> {
  return Curry(Model.init)
    <^> j <| "key1" // <-- Good
    <*> j <| "key2"
    ...
}

static func decode(j: JSON) -> Decoded<Model> {
  return Curry(Model.init)
    <*> j <| "key1" // <-- Bad
    <*> j <| "key2"
    ...
}
```

Simply put, the map operator `<^>` should only be used to the right of the fully
curried function, as it represents the first step of trying to plug a decoded
value into `Model.init`.

Another misuse of the functional operators comes in the form of the following
error:

> Cannot convert call result type 'Decoded<_>' to expected type
'@noescape _ -> _ -> C'

Now we see that `Decoded<>` is mentioned on the left. This happens when you have
used the map operator `<^>` instead of the applicative operator `<*>`:

```swift
static func decode(j: JSON) -> Decoded<Model> {
  return Curry(Model.init)
    <^> j <| "key1"
    <*> j <| "key2" // <-- Good
    ...
}

static func decode(j: JSON) -> Decoded<Model> {
  return Curry(Model.init)
    <^> j <| "key1"
    <^> j <| "key2" // <-- Bad
    ...
}
```
