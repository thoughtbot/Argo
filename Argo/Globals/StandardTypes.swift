import Foundation
import Runes

extension String: JSONDecodable {
  public static func decode(j: JSON) -> String? {
    switch j {
    case let .String(s): return s
    default: return .None
    }
  }
}

extension Int: JSONDecodable {
  public static func decode(j: JSON) -> Int? {
    switch j {
    case let .Number(n): return n as Int
    default: return .None
    }
  }
}

extension Double: JSONDecodable {
  public static func decode(j: JSON) -> Double? {
    switch j {
    case let .Number(n): return n as Double
    default: return .None
    }
  }
}

extension Bool: JSONDecodable {
  public static func decode(j: JSON) -> Bool? {
    switch j {
    case let .Number(n): return n as Bool
    default: return .None
    }
  }
}

extension Float: JSONDecodable {
  public static func decode(j: JSON) -> Float? {
    switch j {
    case let .Number(n): return n as Float
    default: return .None
    }
  }
}

public func decodeArray<A where A: JSONDecodable, A == A.DecodedType>(value: JSON) -> [A]? {
  switch value {
  case let .Array(a): return sequence({ A.decode($0) } <^> a)
  default: return .None
  }
}
