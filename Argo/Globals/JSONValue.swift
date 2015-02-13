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
    case let .JSONArray(a): return sequence(A.decode <^> a)
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
    get {
      switch self {
      case let .JSONObject(o): return o[key]
      default: return .None
      }
    }
    set {
      switch self {
      case var .JSONObject(o):
        o[key] = newValue
        self = .JSONObject(o)
      default:
        assert(false,"Attempted setting subscripted value of a non JSONObject")
      }
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

extension JSONValue: JSONEncodable {
  public func encode() -> JSONValue {
    return self
  }
}

//MARK: Initializers
extension JSONValue {
  public init<T:JSONEncodable>(optional: T?) {
    self = optional?.encode() ?? .JSONNull
  }
  
  public init<T:JSONEncodable>(array: [T]?) {
    self = array?.encode() ?? .JSONNull
  }
  
  public init<K:String,V:JSONEncodable>(dictionary: [K:V]?) {
    self = dictionary?.encode() ?? .JSONNull
  }
}

//MARK: LiteralConvertible

extension JSONValue : StringLiteralConvertible {
  public typealias UnicodeScalarLiteralType = StringLiteralType
  public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
  public init(stringLiteral value: StringLiteralType) {
    self =  .JSONString(value)
  }
  public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
    self =  .JSONString(value)
  }
  public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
    self = .JSONString(value)
  }
}

extension JSONValue : IntegerLiteralConvertible {
  public init(integerLiteral value: IntegerLiteralType) {
    self = .JSONNumber(value)
  }
}

extension JSONValue : FloatLiteralConvertible {
  public init(floatLiteral value: FloatLiteralType) {
    self = .JSONNumber(value)
  }
}

extension JSONValue : BooleanLiteralConvertible {
  public init(booleanLiteral value: BooleanLiteralType) {
    self = .JSONNumber(value)
  }
}

extension JSONValue : DictionaryLiteralConvertible {
  public typealias Key = String
  public typealias Value = JSONEncodable?
  public init(dictionaryLiteral elements: (Key, Value)...) {
    var dictionary : [String:JSONValue] = [:]
    for (key,value) in elements {
      dictionary[key] = value?.encode() ?? .JSONNull
    }
    self = .JSONObject(dictionary)
  }
}

extension JSONValue : ArrayLiteralConvertible {
  public typealias Element = JSONEncodable?
  public init(arrayLiteral elements: Element...) {
    let e = elements.map({$0?.encode() ?? .JSONNull})
    self = .JSONArray(e)
  }
}

extension JSONValue : NilLiteralConvertible {
  public init(nilLiteral: ()) {
    self = .JSONNull
  }
}
