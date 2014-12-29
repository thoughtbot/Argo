// MARK: Values

// Pull embedded value from JSON
public func <|<A: JSONDecodable>(json: JSONValue, keys: [String]) -> A? {
  let object: JSONValue? = keys.reduce(json) { $0?[$1] }
  if let o = object {
    return A.decode(o)
  }

  return .None
}

// Pull value from JSON
public func <|<A: JSONDecodable>(json: JSONValue, key: String) -> A? {
  return json <| [key]
}

// Pull embedded optional value from JSON
public func <|?<A: JSONDecodable>(json: JSONValue, keys: [String]) -> A?? {
  return pure(json <| keys)
}

// Pull optional value from JSON
public func <|?<A: JSONDecodable>(json: JSONValue, key: String) -> A?? {
  return json <|? [key]
}

// MARK: Arrays

// Pull embedded array from JSON
public func <||<A: JSONDecodable>(json: JSONValue, keys: [String]) -> [A]? {
  return keys.reduce(json) { $0?[$1] } >>- JSONValue.map
}

// Pull array from JSON
public func <||<A: JSONDecodable>(json: JSONValue, key: String) -> [A]? {
  return json <|| [key]
}


// Pull embedded optional array from JSON
public func <||?<A: JSONDecodable>(json: JSONValue, keys: [String]) -> [A]?? {
  return pure(json <|| keys)
}

// Pull optional array from JSON
public func <||?<A: JSONDecodable>(json: JSONValue, key: String) -> [A]?? {
  return json <||? [key]
}
