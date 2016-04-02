import Foundation

extension String: Decodable {
  public static func decode(j: JSON) -> Decoded<String> {
    switch j {
    case let .String(s): return pure(s)
    default: return .typeMismatch("String", actual: j)
    }
  }
}

extension Int: Decodable {
  public static func decode(j: JSON) -> Decoded<Int> {
    switch j {
    case let .Number(n): return pure(n as Int)
    default: return .typeMismatch("Int", actual: j)
    }
  }
}

extension Int64: Decodable {
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
  public static func decode(j: JSON) -> Decoded<Double> {
    switch j {
    case let .Number(n): return pure(n as Double)
    default: return .typeMismatch("Double", actual: j)
    }
  }
}

extension Bool: Decodable {
  public static func decode(j: JSON) -> Decoded<Bool> {
    switch j {
    case let .Number(n): return pure(n as Bool)
    default: return .typeMismatch("Bool", actual: j)
    }
  }
}

extension Float: Decodable {
  public static func decode(j: JSON) -> Decoded<Float> {
    switch j {
    case let .Number(n): return pure(n as Float)
    default: return .typeMismatch("Float", actual: j)
    }
  }
}

public extension Optional where Wrapped: Decodable, Wrapped == Wrapped.DecodedType {
  static func decode(j: JSON) -> Decoded<Wrapped?> {
    return .optional(Wrapped.decode(j))
  }
}

public extension CollectionType where Generator.Element: Decodable, Generator.Element == Generator.Element.DecodedType {
  static func decode(j: JSON) -> Decoded<[Generator.Element]> {
    switch j {
    case let .Array(a): return sequence(a.map { Generator.Element.decode($0.json) })
    default: return .typeMismatch("Array", actual: j)
    }
  }
}

public func decodeArray<T: Decodable where T.DecodedType == T>(j: JSON) -> Decoded<[T]> {
  return [T].decode(j)
}

public extension DictionaryLiteralConvertible where Value: Decodable, Value == Value.DecodedType {
  static func decode(j: JSON) -> Decoded<[String: Value]> {
    switch j {
    case let .Object(o): return sequence({ Value.decode($0.json) } <^> o)
    default: return .typeMismatch("Object", actual: j)
    }
  }
}

public func decodeObject<T: Decodable where T.DecodedType == T>(j: JSON) -> Decoded<[String: T]> {
  return [String: T].decode(j)
}

public func decodedJSON(json: JSON, forKey key: String) -> Decoded<JSON> {
  switch json {
  case let .Object(o): return guardNull(key, j: o[key]?.json ?? .Null)
  default: return .typeMismatch("Object", actual: json)
  }
}

private func guardNull(key: String, j: JSON) -> Decoded<JSON> {
  switch j {
  case .Null: return .missingKey(key)
  default: return pure(j)
  }
}
