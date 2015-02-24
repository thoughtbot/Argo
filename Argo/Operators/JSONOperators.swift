import Runes

// MARK: Values

// Pull embedded value from JSON
public func <|<A where A: JSONDecodable, A == A.DecodedType>(json: JSON, keys: [String]) -> A? {
  return foldM(keys, json, <|) >>- { A.decode($0) }
}

// Pull value from JSON
public func <|<A where A: JSONDecodable, A == A.DecodedType>(json: JSON, key: String) -> A? {
  switch json {
  case let .Object(o): return o[key] >>- { A.decode($0) }
  default: return .None
  }
}

// Pull embedded optional value from JSON
public func <|?<A where A: JSONDecodable, A == A.DecodedType>(json: JSON, keys: [String]) -> A?? {
  return pure(json <| keys)
}

// Pull optional value from JSON
public func <|?<A where A: JSONDecodable, A == A.DecodedType>(json: JSON, key: String) -> A?? {
  return pure(json <| key)
}

// MARK: Arrays

// Pull embedded array from JSON
public func <||<A where A: JSONDecodable, A == A.DecodedType>(json: JSON, keys: [String]) -> [A]? {
  return json <| keys >>- decodeArray
}

// Pull array from JSON
public func <||<A where A: JSONDecodable, A == A.DecodedType>(json: JSON, key: String) -> [A]? {
  return json <| key >>- decodeArray
}


// Pull embedded optional array from JSON
public func <||?<A where A: JSONDecodable, A == A.DecodedType>(json: JSON, keys: [String]) -> [A]?? {
  return pure(json <|| keys)
}

// Pull optional array from JSON
public func <||?<A where A: JSONDecodable, A == A.DecodedType>(json: JSON, key: String) -> [A]?? {
  return pure(json <|| key)
}
