import Foundation
import Runes

public typealias JSONDict = [String: JSON]

public enum JSON {
  case JSONObject(JSONDict)
  case JSONArray([JSON])
  case JSONString(String)
  case JSONNumber(NSNumber)
  case JSONNull
}

public extension JSON {
  static func parse(json: AnyObject) -> JSON {
    switch json {
    case let v as [AnyObject]: return .JSONArray(v.map(parse))

    case let v as [String: AnyObject]:
      let object = reduce(v.keys, JSONDict()) { accum, key in
        let append = curry(Dictionary.appendKey)(accum)(key)
        return (append <^> (self.parse <^> v[key])) ?? append(.JSONNull)
      }
      return .JSONObject(object)

    case let v as String: return .JSONString(v)
    case let v as NSNumber: return .JSONNumber(v)
    default: return .JSONNull
    }
  }
}

public extension JSON {
  subscript(key: String) -> JSON? {
    switch self {
    case let .JSONObject(o): return o[key]
    default: return .None
    }
  }

  func find(keys: [String]) -> JSON? {
    return keys.reduce(self) { $0?[$1] }
  }

}

extension JSON: Printable {
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

extension JSON: Equatable { }

public func ==(lhs: JSON, rhs: JSON) -> Bool {
  switch (lhs, rhs) {
  case let (.JSONString(l), .JSONString(r)): return l == r
  case let (.JSONNumber(l), .JSONNumber(r)): return l == r
  case let (.JSONNull, .JSONNull): return true
  case let (.JSONArray(l), .JSONArray(r)): return l == r
  case let (.JSONObject(l), .JSONObject(r)): return l == r
  default: return false
  }
}
