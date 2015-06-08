import Foundation
import Runes

extension String: Decodable {
  public static func decode(j: JSON) -> Decoded<String> {
    switch j {
    case let .String(s): return pure(s)
    default: return typeMismatch("String", forObject: j)
    }
  }
}

extension Int: Decodable {
  public static func decode(j: JSON) -> Decoded<Int> {
    switch j {
    case let .Number(n): return pure(n as Int)
    default: return typeMismatch("Int", forObject: j)
    }
  }
}

extension Int64: Decodable {
  public static func decode(j: JSON) -> Decoded<Int64> {
    switch j {
    case let .Number(n): return pure(n.longLongValue)
    default: return typeMismatch("Int64", forObject: j)
    }
  }
}

extension Double: Decodable {
  public static func decode(j: JSON) -> Decoded<Double> {
    switch j {
    case let .Number(n): return pure(n as Double)
    default: return typeMismatch("Double", forObject: j)
    }
  }
}

extension Bool: Decodable {
  public static func decode(j: JSON) -> Decoded<Bool> {
    switch j {
    case let .Number(n): return pure(n as Bool)
    default: return typeMismatch("Bool", forObject: j)
    }
  }
}

extension Float: Decodable {
  public static func decode(j: JSON) -> Decoded<Float> {
    switch j {
    case let .Number(n): return pure(n as Float)
    default: return typeMismatch("Float", forObject: j)
    }
  }
}

public func decodeArray<A where A: Decodable, A == A.DecodedType>(value: JSON) -> Decoded<[A]> {
  switch value {
  case let .Array(a): return sequence(A.decode <^> a)
  default: return typeMismatch("Array", forObject: value)
  }
}

public func decodeObject<A where A: Decodable, A == A.DecodedType>(value: JSON) -> Decoded<[String: A]> {
  switch value {
  case let .Object(o): return sequence(A.decode <^> o)
  default: return typeMismatch("Object", forObject: value)
  }
}

func decodedJSON(json: JSON, forKey key: String) -> Decoded<JSON> {
  switch json {
  case let .Object(o): return guardNull(key, j: o[key] ?? .Null)
  default: return typeMismatch("Object", forObject: json)
  }
}

private func typeMismatch<T>(expectedType: String, forObject object: JSON) -> Decoded<T> {
  return .TypeMismatch("\(object) is not a \(expectedType)")
}

private func guardNull(key: String, j: JSON) -> Decoded<JSON> {
  switch j {
  case .Null: return .MissingKey(key)
  default: return pure(j)
  }
}
