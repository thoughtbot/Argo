import Foundation
import Runes

extension String: JSONDecodable {
  public static func decode(j: JSON) -> Decoded<String> {
    switch j {
    case let .String(s): return pure(s)
    default: return typeMismatch("String", j)
    }
  }
}

extension Int: JSONDecodable {
  public static func decode(j: JSON) -> Decoded<Int> {
    switch j {
    case let .Number(n): return pure(n as Int)
    default: return typeMismatch("Int", j)
    }
  }
}

extension Double: JSONDecodable {
  public static func decode(j: JSON) -> Decoded<Double> {
    switch j {
    case let .Number(n): return pure(n as Double)
    default: return typeMismatch("Double", j)
    }
  }
}

extension Bool: JSONDecodable {
  public static func decode(j: JSON) -> Decoded<Bool> {
    switch j {
    case let .Number(n): return pure(n as Bool)
    default: return typeMismatch("Bool", j)
    }
  }
}

extension Float: JSONDecodable {
  public static func decode(j: JSON) -> Decoded<Float> {
    switch j {
    case let .Number(n): return pure(n as Float)
    default: return typeMismatch("Float", j)
    }
  }
}

public func decodeArray<A where A: JSONDecodable, A == A.DecodedType>(value: JSON) -> Decoded<[A]> {
  switch value {
  case let .Array(a): return sequence(A.decode <^> a)
  default: return typeMismatch("Array", value)
  }
}

public func decodeObject<A where A: JSONDecodable, A == A.DecodedType>(value: JSON) -> Decoded<[String: A]> {
  switch value {
  case let .Object(o): return sequence(A.decode <^> o)
  default: return typeMismatch("Object", value)
  }
}

private func typeMismatch<T>(expectedType: String, object: JSON) -> Decoded<T> {
  return .TypeMismatch("\(object) is not a \(expectedType)")
}
