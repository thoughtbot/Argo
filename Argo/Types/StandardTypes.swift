import Foundation

extension String: Decodable {
  /**
    Decode `JSON` into `Decoded<String>`

    Succeeds if the value is a string, otherwise it returns a type mismatch.

    - parameter j: The JSON value to decode

    - returns: A decoded `String` value
  */
  public static func decode(j: JSON) -> Decoded<String> {
    switch j {
    case let .String(s): return pure(s)
    default: return .typeMismatch("String", actual: j)
    }
  }
}

extension Int: Decodable {
  /**
    Decode `JSON` into `Decoded<Int>`

    Succeeds if the value is a number that can be converted to an `Int`,
    otherwise it returns a type mismatch.

    - parameter j: The JSON value to decode

    - returns: A decoded `Int` value
  */
  public static func decode(j: JSON) -> Decoded<Int> {
    switch j {
    case let .Number(n): return pure(n as Int)
    default: return .typeMismatch("Int", actual: j)
    }
  }
}

extension Int64: Decodable {
  /**
    Decode `JSON` into `Decoded<Int64>`

    Succeeds if the value is a number that can be converted to an `Int64`,
    otherwise it returns a type mismatch.

    - parameter j: The JSON value to decode

    - returns: A decoded `Int64` value
  */
  public static func decode(j: JSON) -> Decoded<Int64> {
    switch j {
    case let .Number(n): return pure(n.longLongValue)
    case let .String(s):
      guard let i = Int64(s) else { fallthrough }
      return pure(i)
    default: return .typeMismatch("Int64", actual: j)
    }
  }
}

extension Double: Decodable {
  /**
    Decode `JSON` into `Decoded<Double>`

    Succeeds if the value is a number that can be converted to a `Double`,
    otherwise it returns a type mismatch.

    - parameter j: The JSON value to decode

    - returns: A decoded `Double` value
  */
  public static func decode(j: JSON) -> Decoded<Double> {
    switch j {
    case let .Number(n): return pure(n as Double)
    default: return .typeMismatch("Double", actual: j)
    }
  }
}

extension Bool: Decodable {
  /**
    Decode `JSON` into `Decoded<Bool>`

    Succeeds if the value is a number that can be converted to a `Bool`,
    otherwise it returns a type mismatch.

    - parameter j: The JSON value to decode

    - returns: A decoded `Bool` value
  */
  public static func decode(j: JSON) -> Decoded<Bool> {
    switch j {
    case let .Number(n): return pure(n as Bool)
    default: return .typeMismatch("Bool", actual: j)
    }
  }
}

extension Float: Decodable {
  /**
    Decode `JSON` into `Decoded<Float>`

    Succeeds if the value is a number that can be converted to a `Float`,
    otherwise it returns a type mismatch.

    - parameter j: The JSON value to decode

    - returns: A decoded `Float` value
  */
  public static func decode(j: JSON) -> Decoded<Float> {
    switch j {
    case let .Number(n): return pure(n as Float)
    default: return .typeMismatch("Float", actual: j)
    }
  }
}

public extension Optional where Wrapped: Decodable, Wrapped == Wrapped.DecodedType {
  /**
    Decode `JSON` into an optional value where the wrapped value is `Decodable`

    Returns a decoded optional value from the result of performing `decode` on
    the internal wrapped type.

    - parameter j: The JSON value to decode

    - returns: A decoded optional `Wrapped` value
  */
  static func decode(j: JSON) -> Decoded<Wrapped?> {
    return .optional(Wrapped.decode(j))
  }
}

public extension CollectionType where Generator.Element: Decodable, Generator.Element == Generator.Element.DecodedType {
  /**
    Decode `JSON` into an array of values where the elements of the array are
    `Decodable`

    If the `JSON` is an array of `JSON` objects, this returns a decoded array
    of values by mapping the element's `decode` function over the `JSON` and
    then `sequencing` the result. This makes this `Decode` function an
    all-or-nothing operation (See the documentation for `sequence` for more info).

    If the `JSON` is not an array, this returns a type mismatch.

    - parameter j: The JSON calue to decode

    - returns: A decoded array of values
  */
  static func decode(j: JSON) -> Decoded<[Generator.Element]> {
    switch j {
    case let .Array(a): return sequence(a.map(Generator.Element.decode))
    default: return .typeMismatch("Array", actual: j)
    }
  }
}

public extension DictionaryLiteralConvertible where Value: Decodable, Value == Value.DecodedType {
  /**
    Decode `JSON` into a dictionary of keys and values where the keys are
    Strings and the values are `Decodable`

    If the `JSON` is a dictionary of `String`/`JSON` pairs, this returns a decoded dictionary
    of key/value pairs by mapping the value's `decode` function over the `JSON` and
    then `sequencing` the result. This makes this `Decode` function an
    all-or-nothing operation (See the documentation for `sequence` for more info).

    If the `JSON` is not a dictionary, this returns a type mismatch.

    - parameter j: The JSON calue to decode

    - returns: A decoded dictionary of key/value pairs
  */
  static func decode(j: JSON) -> Decoded<[String: Value]> {
    switch j {
    case let .Object(o): return sequence(Value.decode <^> o)
    default: return .typeMismatch("Object", actual: j)
    }
  }
}

/**
  Pull an embedded `JSON` value from a specified key

  If the `JSON` value is an object, it will attempt to return the embedded
  `JSON` value at the specified key, failing if the key doesn't exist.

  If the `JSON` value is not an object, this will return a type mismatch.

  This is similar to adding a subscript to `JSON`, except that it returns a
  `Decoded` type.

  - parameter json: The JSON value that contains the key
  - parameter key: The key containing the embedded `JSON` object

  - returns: a decoded `JSON` value representing the success or failure of
             extracting the value from the object
*/
public func decodedJSON(json: JSON, forKey key: String) -> Decoded<JSON> {
  switch json {
  case let .Object(o): return guardNull(key, j: o[key] ?? .Null)
  default: return .typeMismatch("Object", actual: json)
  }
}

private func guardNull(key: String, j: JSON) -> Decoded<JSON> {
  switch j {
  case .Null: return .missingKey(key)
  default: return pure(j)
  }
}
