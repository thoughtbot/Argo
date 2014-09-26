import Foundation

public typealias JSON = AnyObject

public enum JSONValue: Printable {
  case JSONObject([String:JSONValue])
  case JSONArray([JSONValue])
  case JSONString(String)
  case JSONNumber(NSNumber)
  case JSONNull

  public static func parse(json: JSON) -> JSONValue {
    switch json {
    case let v as [JSON]: return .JSONArray(v.map { self.parse($0) })

    case let v as [String:JSON]:
      var object: [String:JSONValue] = [:]
      for key in v.keys {
        if let value: JSON = v[key] {
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
