import Runes

infix operator <| { associativity left precedence 150 }
infix operator <|? { associativity left precedence 150 }
infix operator <|| { associativity left precedence 150 }
infix operator <||? { associativity left precedence 150 }

// MARK: Values

// Pull value from JSON
public func <| <A where A: Decodable, A == A.DecodedType>(json: JSON, key: String) -> Decoded<A> {
  return decodedJSON(json, forKey: key) >>- A.decode
}

// Pull optional value from JSON
public func <|? <A where A: Decodable, A == A.DecodedType>(json: JSON, key: String) -> Decoded<A?> {
  return .optional(json <| key)
}

// Pull embedded value from JSON
public func <| <A where A: Decodable, A == A.DecodedType>(json: JSON, keys: [String]) -> Decoded<A> {
  return flatReduce(keys, initial: json, combine: decodedJSON) >>- A.decode
}

// Pull embedded optional value from JSON
public func <|? <A where A: Decodable, A == A.DecodedType>(json: JSON, keys: [String]) -> Decoded<A?> {
  return .optional(json <| keys)
}

// MARK: Arrays

// Pull array from JSON
public func <|| <A where A: Decodable, A == A.DecodedType>(json: JSON, key: String) -> Decoded<[A]> {
  return json <| key >>- decodeArray
}

// Pull optional array from JSON
public func <||? <A where A: Decodable, A == A.DecodedType>(json: JSON, key: String) -> Decoded<[A]?> {
  return .optional(json <|| key)
}

// Pull embedded array from JSON
public func <|| <A where A: Decodable, A == A.DecodedType>(json: JSON, keys: [String]) -> Decoded<[A]> {
  return json <| keys >>- decodeArray
}

// Pull embedded optional array from JSON
public func <||? <A where A: Decodable, A == A.DecodedType>(json: JSON, keys: [String]) -> Decoded<[A]?> {
  return .optional(json <|| keys)
}

// MARK: Standard Operators

// Nil Coalescing Support
public func ??<A>(optional: Decoded<A?>, alternateValue: Decoded<A>) -> Decoded<A> {
  switch optional.value {
  case .Some(.Some(let x)): return Decoded.Success(x)
  default: return alternateValue
  }
}

