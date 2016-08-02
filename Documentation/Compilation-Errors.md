# Compilation errors

Swift’s compilation errors can be mystifying if you are not intimately
familiar with the internals of Argo. Here we describe some of the most common
errors and how to fix them.

## Complex expressions

Since the implementation of `decode` on a model consists of fully currying a
method and composing it with many small pieces, each of which may be composed
of many other pieces, it is not surprising that Swift sometimes has difficulty
compiling the expression in a reasonable amount of time. This manifests itself
with the following error:

> Expression was too complex to be solved in reasonable time; consider
> breaking up the expression into distinct sub-expressions.

Fortunately this is easy to solve. A first step is to store
`curry(Model.init)` in a variable instead of using it directly:

```swift
static func decode(json: JSON) -> Decoded<Model> {
  let create = curry(Model.init)
  return create
    <^> json <| "key1"
    <*> json <| "key2"
    ...
```

Many times this can fix the problem. If you still have complex expression
issues, the next step is to pick a midpoint in your decoding chain and set an
intermediate variable:

```swift
static func decode(json: JSON) -> Decoded<Model> {
  let create = curry(Model.init)
  let tmp = create
    <^> json <| "key_a_1"
    <*> json <| "key_a_2"
    ...
  return tmp
    <*> json <| "key_b_1"
    <*> json <| "key_b_2"
    ...
```

This almost always fix all of your complex expression issues, but if not, be
prepared to try one more intermediate variable. Take careful note that in
defining `tmp` we used the map operator `create <^>` but in the return
statement we used the applicative operator `tmp <*>`. The map operator is
_only_ used with the fully curried `init`.

If either of these methods aren't doing the trick, or if you'd prefer to avoid
the temporary variables you can help the compiler by adding more type
information with `as` statements:

```swift
struct Model: Decodable {
  let a: String
  let b: Int

  static func decode(json: JSON) -> Decoded<Model> {
    return curry(Model.init)
      <^> json <| "key1" as Decoded<String> // Note that these types correspond
      <*> json <| "key2" as Decoded<Int>    // to the expected type above
  }
}
```

## Incorrectly decoded fields

When you have not correctly decoded all fields of your model in the `decode`
function you will see an error of the form:

> Cannot invoke 'curry' with an argument list of type 'A -> B -> C'

> Cannot convert value of type 'A -> B -> C' to expected argument type '_ -> _
> -> C'

The latter happens when you are returning `curry(Model.init)` directly, and the
former happens when you have stored `curry(Model.init)` in a variable instead of
returning directly. See the discussion on complex expressions for more
information on why one would do that.

There are a few ways in which you may not have correctly decoded your model:

 * You are missing a `j <| "key"` for a field in your model.
 * You incorrectly decoded the type of a field, e.g. you used `j <|
   "optional_key"` when you meant `j <|? "optional_key"`. Or you used `j <|
   "array_of_objects"` when you wanted `j <|| "array_of_objects"`.
 * You are trying to decode a type that doesn't conform to `Decodable`.

The best way forward is to re-examine all of the fields in your model and make
sure they are accounted for in `decode` and that types match up.

## Misuse of functional operators

When you have misused the map `<^>` or applicative `<*>` operators you will
see errors that mention the `Decoded` type. One such error is:

> No 'curry' candidates produce the expected contextual result type 'Decoded<_
> -> _ -> _ -> C>'

> Cannot convert value of type 'A -> B -> C' to type 'Decoded<_ -> _ -> C>'

The key difference in these errors from the errors generated from incorrectly
decoded fields is the mention of `Decoded<_>` on the right side. This most
likely means that you are using `<*>` when you should be using `<^>`:

```swift
// Correct
static func decode(json: JSON) -> Decoded<Model> {
  return curry(Model.init)
    <^> json <| "key1" // <-- Good
    <*> json <| "key2"
    ...
}

// Incorrect
static func decode(json: JSON) -> Decoded<Model> {
  return curry(Model.init)
    <*> json <| "key1" // <-- Bad
    <*> json <| "key2"
    ...
}
```

Simply put, the map operator `<^>` should only be used for the first argument
to the curried function, as it represents the first step of trying to plug a
decoded value into `Model.init`.

Another misuse of the functional operators comes in the form of the following
error:

> Cannot convert call result type 'Decoded<_>' to expected type '@noescape _
> -> _ -> C'

Now we see that `Decoded<_>` is mentioned on the left. This happens when you have
used the map operator `<^>` instead of the applicative operator `<*>`:

```swift
// Correct
static func decode(json: JSON) -> Decoded<Model> {
  return curry(Model.init)
    <^> json <| "key1"
    <*> json <| "key2" // <-- Good
    ...
}

// Incorrect
static func decode(json: JSON) -> Decoded<Model> {
  return curry(Model.init)
    <^> json <| "key1"
    <^> json <| "key2" // <-- Bad
    ...
}
```
