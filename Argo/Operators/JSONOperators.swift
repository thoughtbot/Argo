import Runes

// MARK: Values

// Pull value from JSON
public func <|<A where A: JSONDecodable, A == A.DecodedType>(json: JSON, key: String) -> A? {
  switch json {
  case let .Object(o): return o[key] >>- { A.decode($0) }
  default: return .None
  }
}

// Pull optional value from JSON
public func <|?<A where A: JSONDecodable, A == A.DecodedType>(json: JSON, key: String) -> A?? {
  return pure(json <| key)
}

// Pull embedded value from JSON
public func <|<A where A: JSONDecodable, A == A.DecodedType>(json: JSON, keys: [String]) -> A? {
  return flatReduce(keys, json, <|) >>- { A.decode($0) }
}

// Pull embedded optional value from JSON
public func <|?<A where A: JSONDecodable, A == A.DecodedType>(json: JSON, keys: [String]) -> A?? {
  return pure(json <| keys)
}

// MARK: Arrays

// Pull array from JSON
public func <||<A where A: JSONDecodable, A == A.DecodedType>(json: JSON, key: String) -> [A]? {
  return json <| key >>- decodeArray
}

// Pull optional array from JSON
public func <||?<A where A: JSONDecodable, A == A.DecodedType>(json: JSON, key: String) -> [A]?? {
  return pure(json <|| key)
}

// Pull embedded array from JSON
public func <||<A where A: JSONDecodable, A == A.DecodedType>(json: JSON, keys: [String]) -> [A]? {
  return json <| keys >>- decodeArray
}

// Pull embedded optional array from JSON
public func <||?<A where A: JSONDecodable, A == A.DecodedType>(json: JSON, keys: [String]) -> [A]?? {
  return pure(json <|| keys)
}
