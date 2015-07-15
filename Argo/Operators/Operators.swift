infix operator <| { associativity left precedence 150 }
infix operator <|? { associativity left precedence 150 }
infix operator <|| { associativity left precedence 150 }
infix operator <||? { associativity left precedence 150 }
infix operator <|> { associativity left precedence 140 }

// MARK: Values

// Pull value from JSON
public func <| <A where A: Decodable, A == A.DecodedType>(json: JSON, key: String) -> Decoded<A> {
//  return decodedJSON(json, forKey: key) >>- A.decode
  return json <| [key]
}

// Pull optional value from JSON
public func <|? <A where A: Decodable, A == A.DecodedType>(json: JSON, key: String) -> Decoded<A?> {
  return .optional(json <| [key])
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
  return json <|| [key]
}

// Pull optional array from JSON
public func <||? <A where A: Decodable, A == A.DecodedType>(json: JSON, key: String) -> Decoded<[A]?> {
  return .optional(json <|| [key])
}

// Pull embedded array from JSON
public func <|| <A where A: Decodable, A == A.DecodedType>(json: JSON, keys: [String]) -> Decoded<[A]> {
  return flatReduce(keys, initial: json, combine: decodedJSON) >>- Array<A>.decode
}

// Pull embedded optional array from JSON
public func <||? <A where A: Decodable, A == A.DecodedType>(json: JSON, keys: [String]) -> Decoded<[A]?> {
  return .optional(json <|| keys)
}

// MARK: Alternative operator
public func <|><A>(lhs: Decoded<A>, rhs: Decoded<A>) -> Decoded<A> {
  if case .Success = lhs {
    return lhs
  }
  return rhs
}
