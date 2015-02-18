import Foundation
import Runes

public typealias JSONDict = [String: JSONValue]

public enum JSONValue {
  case JSONObject(JSONDict)
  case JSONArray([JSONValue])
  case JSONString(String)
  case JSONNumber(NSNumber)
  case JSONNull
}

public extension JSONValue {
  static func parse(json: AnyObject) -> JSONValue {
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

  static func mapDecode<A where A: JSONDecodable, A == A.DecodedType>(value: JSONValue) -> [A]? {
    switch value {
    case let .JSONArray(a): return sequence({ A.decode($0) } <^> a)
    default: return .None
    }
  }
}

public extension JSONValue {
  func value<A>() -> A? {
    switch self {
    case let .JSONString(v): return v as? A
    case let .JSONNumber(v): return v as? A
    case let .JSONNull: return .None
    case let .JSONArray(a): return a as? A
    case let .JSONObject(o): return o as? A
    }
  }

  subscript(key: String) -> JSONValue? {
    switch self {
    case let .JSONObject(o): return o[key]
    default: return .None
    }
  }

  func find(keys: [String]) -> JSONValue? {
    return keys.reduce(self) { $0?[$1] }
  }

}

extension JSONValue: Printable {
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

extension JSONValue: Equatable { }

public func ==(lhs: JSONValue, rhs: JSONValue) -> Bool {
  switch (lhs, rhs) {
  case let (.JSONString(l), .JSONString(r)): return l == r
  case let (.JSONNumber(l), .JSONNumber(r)): return l == r
  case let (.JSONNull, .JSONNull): return true
  case let (.JSONArray(l), .JSONArray(r)): return l == r
  case let (.JSONObject(l), .JSONObject(r)): return l == r
  default: return false
  }
}
