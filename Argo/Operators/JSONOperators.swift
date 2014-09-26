import Foundation

public func <|<A: JSONDecodable>(d: JSONObject, key: String) -> A? {
  return d[key] >>- _JSONParse
}

public func <|(d: JSONObject, key: String) -> JSONObject {
  return d[key] >>- _JSONParse ?? JSONObject()
}

public func <|<A: JSONDecodable>(d: JSONObject, key: String) -> [A]? {
  return d[key] >>- _JSONParse >>- { (array: JSONArray) in
    array.map { _JSONParse($0) } >>- flatten
  }
}

public func <|*<A: JSONDecodable>(d: JSONObject, key: String) -> A?? {
  return pure(d <| key)
}
