import Foundation
import Runes

extension String: Decodable {
  /**
    Decode `Value` into `Decoded<String>`.

    Succeeds if the value is a string, otherwise it returns a type mismatch.

    - parameter value: The `Value` to decode

    - returns: A decoded `String` value
  */
  public static func decode(_ value: Value) -> Decoded<String> {
    switch value {
    case let .string(s): return pure(s)
    default: return .typeMismatch(expected: "String", actual: value)
    }
  }
}

extension Int: Decodable {
  /**
    Decode `Value` into `Decoded<Int>`.

    Succeeds if the value is a number that can be converted to an `Int`,
    otherwise it returns a type mismatch.

    - parameter value: The `Value` to decode

    - returns: A decoded `Int` value
  */
  public static func decode(_ value: Value) -> Decoded<Int> {
    switch value {
    case let .number(n): return pure(n.intValue)
    default: return .typeMismatch(expected: "Int", actual: value)
    }
  }
}

extension UInt: Decodable {
  /**
    Decode `Value` into `Decoded<UInt>`.

    Succeeds if the value is a number that can be converted to a `UInt`,
    otherwise it returns a type mismatch.

    - parameter value: The `Value` to decode

    - returns: A decoded `UInt` value
  */
  public static func decode(_ value: Value) -> Decoded<UInt> {
    switch value {
    case let .number(n): return pure(n.uintValue)
    default: return .typeMismatch(expected: "UInt", actual: value)
    }
  }
}

extension Int64: Decodable {
  /**
    Decode `Value` into `Decoded<Int64>`.

    Succeeds if the value is a number that can be converted to an `Int64` or a
    string that represents a large number, otherwise it returns a type
    mismatch.

    - parameter value: The `Value` to decode

    - returns: A decoded `Int64` value
  */
  public static func decode(_ value: Value) -> Decoded<Int64> {
    switch value {
    case let .number(n): return pure(n.int64Value)
    case let .string(s):
      guard let i = Int64(s) else { fallthrough }
      return pure(i)
    default: return .typeMismatch(expected: "Int64", actual: value)
    }
  }
}

extension UInt64: Decodable {
  /**
    Decode `Value` into `Decoded<UInt64>`.

    Succeeds if the value is a number that can be converted to an `UInt64` or a
    string that represents a large number, otherwise it returns a type
    mismatch.

    - parameter value: The `Value` to decode

    - returns: A decoded `UInt` value
  */
  public static func decode(_ value: Value) -> Decoded<UInt64> {
    switch value {
    case let .number(n): return pure(n.uint64Value)
    case let .string(s):
      guard let i = UInt64(s) else { fallthrough }
      return pure(i)
    default: return .typeMismatch(expected: "UInt64", actual: value)
    }
  }
}

extension Double: Decodable {
  /**
    Decode `Value` into `Decoded<Double>`.

    Succeeds if the value is a number that can be converted to a `Double`,
    otherwise it returns a type mismatch.

    - parameter value: The `Value` to decode

    - returns: A decoded `Double` value
  */
  public static func decode(_ value: Value) -> Decoded<Double> {
    switch value {
    case let .number(n): return pure(n.doubleValue)
    default: return .typeMismatch(expected: "Double", actual: value)
    }
  }
}

extension Float: Decodable {
  /**
    Decode `Value` into `Decoded<Float>`.

    Succeeds if the value is a number that can be converted to a `Float`,
    otherwise it returns a type mismatch.

    - parameter value: The `Value` to decode

    - returns: A decoded `Float` value
  */
  public static func decode(_ value: Value) -> Decoded<Float> {
    switch value {
    case let .number(n): return pure(n.floatValue)
    default: return .typeMismatch(expected: "Float", actual: value)
    }
  }
}

extension Bool: Decodable {
  /**
    Decode `Value` into `Decoded<Bool>`.

    Succeeds if the value is a boolean or if the value is a number that is able
    to be converted to a boolean, otherwise it returns a type mismatch.

    - parameter value: The `Value` to decode

    - returns: A decoded `Bool` value
  */
  public static func decode(_ value: Value) -> Decoded<Bool> {
    switch value {
    case let .bool(n): return pure(n)
    case let .number(n): return pure(n.boolValue)
    default: return .typeMismatch(expected: "Bool", actual: value)
    }
  }
}

public extension Optional where Wrapped: Decodable, Wrapped == Wrapped.DecodedType {
  /**
    Decode `Value` into an `Optional<Wrapped>` value where `Wrapped` is `Decodable`.

    Returns a decoded optional value from the result of performing `decode` on
    the internal wrapped type.

    - parameter value: The `Value` to decode

    - returns: A decoded optional `Wrapped` value
  */
  static func decode(_ value: Value) -> Decoded<Wrapped?> {
    return Wrapped.decode(value) >>- { .success(.some($0)) }
  }
}

extension Array: Decodable where Element: Decodable, Element == Element.DecodedType {
  /**
    Decode `Value` into an array of values where the elements of the array are
    `Decodable`.

    If the `Value` is an array of `Value` objects, this returns a decoded array
    of values by mapping the element's `decode` function over the `Value` and
    then applying `sequence` to the result. This makes this `decode` function
    an all-or-nothing operation (See the documentation for `sequence` for more
    info).

    If the `Value` is not an array, this returns a type mismatch.

    - parameter value: The `Value` to decode

    - returns: A decoded array of values
  */
  public static func decode(_ value: Value) -> Decoded<Array> {
    switch value {
    case let .array(a): return sequence(a.map(Iterator.Element.decode))
    default: return .typeMismatch(expected: "Array", actual: value)
    }
  }
}

extension Dictionary: Decodable where Value: Decodable, Value == Value.DecodedType, Key == String {
  /**
    Decode `Value` into a dictionary of keys and values where the keys are
    `String`s and the values are `Decodable`.

    If the `Value` is a dictionary of `String`/`Value` pairs, this returns a decoded dictionary
    of key/value pairs by mapping the value's `decode` function over the `Value` and
    then applying `sequence` to the result. This makes this `decode` function
    an all-or-nothing operation (See the documentation for `sequence` for more
    info).

    If the `Value` is not a dictionary, this returns a type mismatch.

    - parameter value: The `Value` to decode

    - returns: A decoded dictionary of key/value pairs
  */
  public static func decode(_ value: Argo.Value) -> Decoded<Dictionary> {
    switch value {
    case let .object(o): return sequence(Value.decode <^> o)
    default: return .typeMismatch(expected: "Object", actual: value)
    }
  }
}

/**
  Pull an embedded `Value` from a specified key.

  If the `Value` is an object, it will attempt to return the embedded
  `Value` at the specified key, failing if the key doesn't exist.

  If the `Value` is not an object, this will return a type mismatch.

  This is similar to adding a subscript to `Value`, except that it returns a
  `Decoded` type.

  - parameter value: The `Value` that contains the key
  - parameter key: The key containing the embedded `Value` object

  - returns: A decoded `Value` representing the success or failure of
             extracting the value from the object
*/
public func decodedValue(_ value: Value, forKey key: String) -> Decoded<Value> {
  switch value {
  case let .object(o): return guardNull(key, o[key] ?? .null)
  default: return .typeMismatch(expected: "Object", actual: value)
  }
}

private func guardNull(_ key: String, _ value: Value) -> Decoded<Value> {
  switch value {
  case .null: return .missingKey(key)
  default: return pure(value)
  }
}
