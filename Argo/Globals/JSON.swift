import Foundation

extension String: JSONDecodable {
  public static func decode(json: JSONValue) -> String? {
    switch json {
    case let .JSONString(s): return s
    default: return .None
    }
  }
}

extension Int: JSONDecodable {
  public static func decode(json: JSONValue) -> Int? {
    switch json {
    case let .JSONNumber(i): return Int(i)
    default: return .None
    }
  }
}

extension Double: JSONDecodable {
  public static func decode(json: JSONValue) -> Double? {
    switch json {
    case let .JSONNumber(d): return Double(d)
    default: return .None
    }
  }
}

extension Bool: JSONDecodable {
  public static func decode(json: JSONValue) -> Bool? {
    switch json {
    case let .JSONNumber(b): return b == 0 ? false : true
    default: return .None
    }
  }
}
