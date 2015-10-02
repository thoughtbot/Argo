// MARK: Values

// Pull value from JSON
public func <| <A where A: Decodable, A == A.DecodedType>(json: JSON, key: String) -> Decoded<A> {
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
