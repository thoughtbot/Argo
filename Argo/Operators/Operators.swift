infix operator <| { associativity left precedence 150 }
infix operator <|? { associativity left precedence 150 }
infix operator <|| { associativity left precedence 150 }
infix operator <||? { associativity left precedence 150 }

// MARK: Values

// Pull value from JSON
public func <| <A where A: Decodable, A == A.DecodedType>(json: JSON, key: String) throws -> A {
  return try A.decode(decodedJSON(json, forKey: key))
}

// Pull optional value from JSON
public func <|? <A where A: Decodable, A == A.DecodedType>(json: JSON, key: String) throws -> A? {
  return try .Some(json <| key)
}

// Pull embedded value from JSON
public func <| <A where A: Decodable, A == A.DecodedType>(json: JSON, keys: [String]) throws -> A {
  return try A.decode(flatReduce(keys, initial: json, combine: decodedJSON))
}

// Pull embedded optional value from JSON
public func <|? <A where A: Decodable, A == A.DecodedType>(json: JSON, keys: [String]) throws -> A? {
  return try .Some(json <| keys)
}

// MARK: Arrays

// Pull array from JSON
public func <|| <A where A: Decodable, A == A.DecodedType>(json: JSON, key: String) throws -> [A] {
  return try decodeArray(json <| key)
}

// Pull optional array from JSON
public func <||? <A where A: Decodable, A == A.DecodedType>(json: JSON, key: String) throws -> [A]? {
  return try .Some(json <|| key)
}

// Pull embedded array from JSON
public func <|| <A where A: Decodable, A == A.DecodedType>(json: JSON, keys: [String]) throws -> [A] {
  return try decodeArray(json <| keys)
}

// Pull embedded optional array from JSON
public func <||? <A where A: Decodable, A == A.DecodedType>(json: JSON, keys: [String]) throws -> [A]? {
  return try .Some(json <|| keys)
}

