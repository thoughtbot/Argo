import Foundation

public enum JSON {
  case Object([Swift.String: LazyJSON])
  case Array([LazyJSON])
  case String(Swift.String)
  case Number(NSNumber)
  case Null
}

public extension JSON {
  static func parse(json: AnyObject) -> JSON {
    switch json {
    case let v as [AnyObject]: return .Array(v.map(LazyJSON.init))
    case let v as [Swift.String: AnyObject]: return .Object(v.map(LazyJSON.init))
    case let v as Swift.String: return .String(v)
    case let v as NSNumber: return .Number(v)
    default: return .Null
    }
  }
}

extension JSON: Decodable {
  public static func decode(j: JSON) -> Decoded<JSON> {
    return pure(j)
  }
}

extension JSON: CustomStringConvertible {
  public var description: Swift.String {
    switch self {
    case let .String(v): return "String(\(v))"
    case let .Number(v): return "Number(\(v))"
    case let .Array(a): return "Array(\(a.description))"
    case let .Object(o): return "Object(\(o.description))"
    case .Null: return "Null"
    }
  }
}

extension JSON: Equatable { }

public func == (lhs: JSON, rhs: JSON) -> Bool {
  switch (lhs, rhs) {
  case let (.String(l), .String(r)): return l == r
  case let (.Number(l), .Number(r)): return l == r
  case let (.Array(l), .Array(r)): return l == r
  case let (.Object(l), .Object(r)): return l == r
  case (.Null, .Null): return true
  default: return false
  }
}

public final class LazyJSON {
  private let _value: AnyObject

  public lazy var json: JSON = {
    return JSON.parse(self._value)
  }()

  public init(_ value: AnyObject) {
    _value = value
  }
}

extension LazyJSON: CustomStringConvertible {
  public var description: Swift.String {
    return self.json.description
  }
}

extension LazyJSON: Equatable { }

public func == (lhs: LazyJSON, rhs: LazyJSON) -> Bool {
  return lhs.json == rhs.json
}
