import Foundation

public func <|<A: JSONDecodable>(value: JSONValue, key: String) -> A? {
  switch value {
  case let .JSONObject(o):
    if let v = o[key] {
      return A.decode(v)
    }
    fallthrough

  default: return .None
  }
}

public func <|(value: JSONValue, key: String) -> JSONValue {
  switch value {
  case let .JSONObject(o):
    if let d = o[key] {
      return d
    }
    fallthrough

  default: return .JSONObject([:])
  }
}

public func <|<A: JSONDecodable>(value: JSONValue, key: String) -> [A]? {
  switch value {
  case let .JSONObject(o):
    let v: JSONValue? = o[key]

    if let val = v {
      switch val {
      case let .JSONArray(a):
        var list: [A?] = []
        for item in a {
          list.append(A.decode(item))
        }
        return flatten(list)
      default: break
      }
    }
    fallthrough

  default: return .None
  }
}

public func <|*<A: JSONDecodable>(d: JSONValue, key: String) -> A?? {
  return pure(d <| key)
}
