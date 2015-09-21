# Decoding Enums

Decoding Structs and Classes is a similar process, but Enums can mix things up.
If your Enum inherits from a Raw Type (`String` or `Int`), then making it
conform to `Decodable` is as simple as pie. Let's look at a `Role` type enum:

```swift
enum Role: String {
  case User 
  case Admin
  case SuperAdmin
}
```

To make `Role` conform to `Decodable`, use this one line:

```swift
extension Role: Decodable { }
```

"THAT'S IT?! How?", you ask. Enums with a raw type like `String` or `Int`
conform to `RawRepresentable`. Enums that are `RawRepresentable` are given a
default value by the Swift compiler. With `Int`, the first case is `0` and each
case is one more than the previous case. With `String`, the default raw value
is the case name. So for `Role`, the raw value that represents the case `User`
is `"User"`. `RawRepresentable` enums also get a default initialize
`init(rawValue: )`. We added a [default implementation] to Argo for `Int` and
`String` enums so decoding can be this simple.

[default implementation]: ../Argo/Extensions/RawRepresentable.swift

So, what if the enum doesn't have a raw type? Conforming to `Decodable` is a
bit more involved but not too hard. Let's look at an example:

```swift
enum FootRace {
  case HalfMarathon
  case Marathon
  case UltraMarathon
}
```

We can write `Decodable` for `FootRace` like so:

```swift
extension FootRace: Decodable {
  static func decode(j: JSON) -> Decoded<FootRace> {
    switch j {

    // First, make sure JSON is a number.
    case let .Number(distance):

      // Next, match the number to the enum case.
      switch distance {

      // When a case matches, use pure to wrap the enum in Decoded.
      case 13.1: return pure(.HalfMarathon)
      case 26.2: return pure(.Marathon)
      case _ where distance > 26.2: return pure(.UltraMarathon)

      // Return an error if no case matched
      default: return .typeMismatch("marathon distance", actual: distance)
      }

    // Return an error if JSON is not a number.
    default: return .typeMismatch("Number", actual: j)
    }
  }
}
```
