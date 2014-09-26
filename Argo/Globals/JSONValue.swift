import Foundation

public enum JSONValue: Printable {
  case JSONObject([String:JSONValue])
  case JSONArray([JSONValue])
  case JSONString(String)
  case JSONNumber(NSNumber)
  case JSONNull

  public static func parse(json: AnyObject) -> JSONValue {
    switch json {
    case let v as [AnyObject]: return .JSONArray(v.map { self.parse($0) })

    case let v as [String:AnyObject]:
      var object: [String:JSONValue] = [:]
      for key in v.keys {
        if let value: AnyObject = v[key] {
          object[key] = parse(value)
        } else {
          object[key] = .JSONNull
        }
      }
      return .JSONObject(object)

    case let v as String: return .JSONString(v)
    case let v as NSNumber: return .JSONNumber(v)
    default: return .JSONNull
    }
  }

  public func value<A>() -> A? {
    switch self {
    case let .JSONString(v): return v as? A
    case let .JSONNumber(v): return v as? A
    case let .JSONNull: return .None
    case let .JSONArray(a): return a as? A
    case let .JSONObject(o): return o as? A
    }
  }

  public subscript(key: String) -> JSONValue? {
    switch self {
    case let .JSONObject(o): return o[key]
    default: return .None
    }
  }

  public static func map<A: JSONDecodable>(value: JSONValue) -> [A]? {
    switch value {
    case let .JSONArray(a): return a.map { A.decoder($0) } >>- flatten
    default: return .None
    }
  }

  public var description: String {
    switch self {
    case let .JSONString(v): return "String(\(v))"
    case let .JSONNumber(v): return "Number(\(v))"
    case let .JSONNull: return "Null"
    case let .JSONArray(a): return "Array(\(a.description))"
    case let .JSONObject(o): return "Object(\(o.description))"
    }
  }
}
