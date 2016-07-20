import Foundation

extension String: Decodable {
  /**
    Decode `JSON` into `Decoded<String>`.

    Succeeds if the value is a string, otherwise it returns a type mismatch.

    - parameter json: The `JSON` value to decode

    - returns: A decoded `String` value
  */
  public static func decode(_ json: JSON) -> Decoded<String> {
    switch json {
    case let .String(s): return pure(s)
    default: return .typeMismatch(expected: "String", actual: json)
    }
  }
}

extension Int: Decodable {
  /**
    Decode `JSON` into `Decoded<Int>`.

    Succeeds if the value is a number that can be converted to an `Int`,
    otherwise it returns a type mismatch.

    - parameter json: The `JSON` value to decode

    - returns: A decoded `Int` value
  */
  public static func decode(_ json: JSON) -> Decoded<Int> {
    switch json {
    case let .Number(n): return pure(n as Int)
    default: return .typeMismatch(expected: "Int", actual: json)
    }
  }
}

extension Int64: Decodable {
  /**
    Decode `JSON` into `Decoded<Int64>`.

    Succeeds if the value is a number that can be converted to an `Int64` or a
    string that represents a large number, otherwise it returns a type
    mismatch.

    - parameter json: The `JSON` value to decode

    - returns: A decoded `Int64` value
  */
  public static func decode(_ json: JSON) -> Decoded<Int64> {
    switch json {
    case let .Number(n): return pure(n.int64Value)
    case let .String(s):
      guard let i = Int64(s) else { fallthrough }
      return pure(i)
    default: return .typeMismatch(expected: "Int64", actual: json)
    }
  }
}

extension Double: Decodable {
  /**
    Decode `JSON` into `Decoded<Double>`.

    Succeeds if the value is a number that can be converted to a `Double`,
    otherwise it returns a type mismatch.

    - parameter json: The `JSON` value to decode

    - returns: A decoded `Double` value
  */
  public static func decode(_ json: JSON) -> Decoded<Double> {
    switch json {
    case let .Number(n): return pure(n as Double)
    default: return .typeMismatch(expected: "Double", actual: json)
    }
  }
}

extension Float: Decodable {
  /**
    Decode `JSON` into `Decoded<Float>`.

    Succeeds if the value is a number that can be converted to a `Float`,
    otherwise it returns a type mismatch.

    - parameter json: The `JSON` value to decode

    - returns: A decoded `Float` value
  */
  public static func decode(_ json: JSON) -> Decoded<Float> {
    switch json {
    case let .Number(n): return pure(n as Float)
    default: return .typeMismatch(expected: "Float", actual: json)
    }
  }
}

extension Bool: Decodable {
  /**
    Decode `JSON` into `Decoded<Bool>`.

    Succeeds if the value is a boolean or if the value is a number that is able
    to be converted to a boolean, otherwise it returns a type mismatch.

    - parameter json: The `JSON` value to decode

    - returns: A decoded `Bool` value
  */
  public static func decode(_ json: JSON) -> Decoded<Bool> {
    switch json {
    case let .Bool(n): return pure(n)
    case let .Number(n): return pure(n as Bool)
    default: return .typeMismatch(expected: "Bool", actual: json)
    }
  }
}

public extension Optional where Wrapped: Decodable, Wrapped == Wrapped.DecodedType {
  /**
    Decode `JSON` into an `Optional<Wrapped>` value where `Wrapped` is `Decodable`.

    Returns a decoded optional value from the result of performing `decode` on
    the internal wrapped type.

    - parameter json: The `JSON` value to decode

    - returns: A decoded optional `Wrapped` value
  */
  static func decode(_ json: JSON) -> Decoded<Wrapped?> {
    return .optional(Wrapped.decode(json))
  }
}

public extension Collection where Iterator.Element: Decodable, Iterator.Element == Iterator.Element.DecodedType {
  /**
    Decode `JSON` into an array of values where the elements of the array are
    `Decodable`.

    If the `JSON` is an array of `JSON` objects, this returns a decoded array
    of values by mapping the element's `decode` function over the `JSON` and
    then applying `sequence` to the result. This makes this `decode` function
    an all-or-nothing operation (See the documentation for `sequence` for more
    info).

    If the `JSON` is not an array, this returns a type mismatch.

    - parameter json: The `JSON` value to decode

    - returns: A decoded array of values
  */
  static func decode(_ json: JSON) -> Decoded<[Generator.Element]> {
    switch json {
    case let .Array(a):
      if a.count > 100 {
        let final = divideAndConquer(input: a, transform: Generator.Element.decode)
        return sequence(final)
      } else {
        return sequence(a.map(Generator.Element.decode))
      }

    default: return .typeMismatch(expected: "Array", actual: json)
    }
  }
}

/**
  Decode `JSON` into an array of values where the elements of the array are
  `Decodable`.

  If the `JSON` is an array of `JSON` objects, this returns a decoded array
  of values by mapping the element's `decode` function over the `JSON` and
  then applying `sequence` to the result. This makes `decodeArray` an
  all-or-nothing operation (See the documentation for `sequence` for more
  info).

  If the `JSON` is not an array, this returns a type mismatch.

  This is a convenience function that is the same as `[T].decode(json)` (where `T`
  is `Decodable`) and only exists to ease some pain around needing to use the
  full type of the array when calling `decode`. We expect this function to be
  removed in a future version.

  - parameter json: The `JSON` value to decode

  - returns: A decoded array of values
*/
public func decodeArray<T: Decodable where T.DecodedType == T>(_ json: JSON) -> Decoded<[T]> {
  return [T].decode(json)
}

public extension DictionaryLiteralConvertible where Value: Decodable, Value == Value.DecodedType {
  /**
    Decode `JSON` into a dictionary of keys and values where the keys are
    `String`s and the values are `Decodable`.

    If the `JSON` is a dictionary of `String`/`JSON` pairs, this returns a decoded dictionary
    of key/value pairs by mapping the value's `decode` function over the `JSON` and
    then applying `sequence` to the result. This makes this `decode` function
    an all-or-nothing operation (See the documentation for `sequence` for more
    info).

    If the `JSON` is not a dictionary, this returns a type mismatch.

    - parameter json: The `JSON` value to decode

    - returns: A decoded dictionary of key/value pairs
  */
  static func decode(_ json: JSON) -> Decoded<[String: Value]> {
    switch json {
    case let .Object(o): return sequence(Value.decode <^> o)
    default: return .typeMismatch(expected: "Object", actual: json)
    }
  }
}

/**
  Decode `JSON` into a dictionary of keys and values where the keys are
  `String`s and the values are `Decodable`.

  If the `JSON` is a dictionary of `String`/`JSON` pairs, this returns a
  decoded dictionary of key/value pairs by mapping the value's `decode`
  function over the `JSON` and then applying `sequence` to the result. This
  makes `decodeObject` an all-or-nothing operation (See the documentation for
  `sequence` for more info).

  If the `JSON` is not a dictionary, this returns a type mismatch.

  This is a convenience function that is the same as `[String: T].decode(json)`
  (where `T` is `Decodable`) and only exists to ease some pain around needing to
  use the full type of the dictionary when calling `decode`. We expect this
  function to be removed in a future version.

  - parameter json: The `JSON` value to decode

  - returns: A decoded dictionary of key/value pairs
*/
public func decodeObject<T: Decodable where T.DecodedType == T>(_ json: JSON) -> Decoded<[String: T]> {
  return [String: T].decode(json)
}

/**
  Pull an embedded `JSON` value from a specified key.

  If the `JSON` value is an object, it will attempt to return the embedded
  `JSON` value at the specified key, failing if the key doesn't exist.

  If the `JSON` value is not an object, this will return a type mismatch.

  This is similar to adding a subscript to `JSON`, except that it returns a
  `Decoded` type.

  - parameter json: The `JSON` value that contains the key
  - parameter key: The key containing the embedded `JSON` object

  - returns: A decoded `JSON` value representing the success or failure of
             extracting the value from the object
*/
public func decodedJSON(_ json: JSON, forKey key: String) -> Decoded<JSON> {
  switch json {
  case let .Object(o): return guardNull(key, o[key] ?? .Null)
  default: return .typeMismatch(expected: "Object", actual: json)
  }
}

private func guardNull(_ key: String, _ json: JSON) -> Decoded<JSON> {
  switch json {
  case .Null: return .missingKey(name: key)
  default: return pure(json)
  }
}
