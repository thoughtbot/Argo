import Foundation

/// A type safe representation of JSON.
public enum JSON {
  case Object([Swift.String: JSON])
  case Array([JSON])
  case String(Swift.String)
  case Number(NSNumber)
  case Bool(Swift.Bool)
  case Null
}

public extension JSON {
  /**
    Transform an `AnyObject` instance into `JSON`.

    This is used to move from a loosely typed object (like those returned from
    `NSJSONSerialization`) to the strongly typed `JSON` tree structure.

    - parameter json: A loosely typed object
  */
  init(_ json: AnyObject) {
    switch json {

    case let v as [AnyObject]:
      self = .Array(v.map(JSON.init))

    case let v as [Swift.String: AnyObject]:
      self = .Object(v.map(JSON.init))

    case let v as Swift.String:
      self = .String(v)

    case let v as NSNumber:
      if v.isBool {
        self = .Bool(v as Swift.Bool)
      } else {
        self = .Number(v)
      }

    default:
      self = .Null
    }
  }
}

extension JSON: Decodable {
  /**
    Decode `JSON` into `Decoded<JSON>`.

    This simply wraps the provided `JSON` in `.Success`. This is useful because
    it means we can use `JSON` values with the `<|` family of operators to pull
    out sub-keys.

    - parameter j: The `JSON` value to decode

    - returns: The provided `JSON` wrapped in `.Success`
  */
  public static func decode(j: JSON) -> Decoded<JSON> {
    return pure(j)
  }
}

extension JSON: CustomStringConvertible {
  public var description: Swift.String {
    switch self {
    case let .String(v): return "String(\(v))"
    case let .Number(v): return "Number(\(v))"
    case let .Bool(v): return "Bool(\(v))"
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
  case let (.Bool(l), .Bool(r)): return l == r
  case let (.Array(l), .Array(r)): return l == r
  case let (.Object(l), .Object(r)): return l == r
  case (.Null, .Null): return true
  default: return false
  }
}

/// MARK: Deprecations

extension JSON {
  @available(*, deprecated=3.0, renamed="init")
  static func parse(json: AnyObject) -> JSON {
    return JSON(json)
  }
}
