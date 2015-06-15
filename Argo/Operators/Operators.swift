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
  do {
    return try .Some(json <| key)
  } catch let error as DecodedError {
    switch error {
    case .MissingKey(_): return .None
    default: throw error
    }
  }
}

// Pull embedded value from JSON
public func <| <A where A: Decodable, A == A.DecodedType>(json: JSON, keys: [String]) throws -> A {
  return try A.decode(flatReduce(keys, initial: json, combine: decodedJSON))
}

// Pull embedded optional value from JSON
public func <|? <A where A: Decodable, A == A.DecodedType>(json: JSON, keys: [String]) throws -> A? {
  do {
    return try .Some(json <| keys)
  } catch let error as DecodedError {
    switch error {
    case .MissingKey(_): return .None
    default: throw error
    }
  }
}

// MARK: Arrays

// Pull array from JSON
public func <|| <A where A: Decodable, A == A.DecodedType>(json: JSON, key: String) throws -> [A] {
  return try decodeArray(json <| key)
}

// Pull optional array from JSON
public func <||? <A where A: Decodable, A == A.DecodedType>(json: JSON, key: String) throws -> [A]? {
  do {
    return try .Some(json <|| key)
  } catch let error as DecodedError {
    switch error {
    case .MissingKey(_): return .None
    default: throw error
    }
  }
}

// Pull embedded array from JSON
public func <|| <A where A: Decodable, A == A.DecodedType>(json: JSON, keys: [String]) throws -> [A] {
  return try decodeArray(json <| keys)
}

// Pull embedded optional array from JSON
public func <||? <A where A: Decodable, A == A.DecodedType>(json: JSON, keys: [String]) throws -> [A]? {
  do {
    return try .Some(json <|| keys)
  } catch let error as DecodedError {
    switch error {
    case .MissingKey(_): return .None
    default: throw error
    }
  }
}

