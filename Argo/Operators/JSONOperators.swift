import Runes

// MARK: Values

// Pull embedded value from JSON
public func <|<A where A: JSONDecodable, A == A.DecodedType>(json: JSONValue, keys: [String]) -> A? {
  return json.find(keys) >>- { A.decode($0) }
}

// Pull value from JSON
public func <|<A where A: JSONDecodable, A == A.DecodedType>(json: JSONValue, key: String) -> A? {
  return json <| [key]
}

// Pull embedded optional value from JSON
public func <|?<A where A: JSONDecodable, A == A.DecodedType>(json: JSONValue, keys: [String]) -> A?? {
  return pure(json <| keys)
}

// Pull optional value from JSON
public func <|?<A where A: JSONDecodable, A == A.DecodedType>(json: JSONValue, key: String) -> A?? {
  return json <|? [key]
}

// MARK: Arrays

// Pull embedded array from JSON
public func <||<A where A: JSONDecodable, A == A.DecodedType>(json: JSONValue, keys: [String]) -> [A]? {
  return json.find(keys) >>- JSONValue.mapDecode
}

// Pull array from JSON
public func <||<A where A: JSONDecodable, A == A.DecodedType>(json: JSONValue, key: String) -> [A]? {
  return json <|| [key]
}


// Pull embedded optional array from JSON
public func <||?<A where A: JSONDecodable, A == A.DecodedType>(json: JSONValue, keys: [String]) -> [A]?? {
  return pure(json <|| keys)
}

// Pull optional array from JSON
public func <||?<A where A: JSONDecodable, A == A.DecodedType>(json: JSONValue, key: String) -> [A]?? {
  return json <||? [key]
}
