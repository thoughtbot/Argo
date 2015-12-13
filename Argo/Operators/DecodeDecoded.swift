// MARK: Values

// Pull value from JSON
public func <| <T where T: Decodable, T == T.DecodedType>(json: JSON, key: String) -> Decoded<T> {
  return json <| [key]
}

// Pull optional value from JSON
public func <|? <T where T: Decodable, T == T.DecodedType>(json: JSON, key: String) -> Decoded<T?> {
  return .optional(json <| [key])
}

// Pull embedded value from JSON
public func <| <T where T: Decodable, T == T.DecodedType>(json: JSON, keys: [String]) -> Decoded<T> {
  return flatReduce(keys, initial: json, combine: decodedJSON) >>- T.decode
}

// Pull embedded optional value from JSON
public func <|? <T where T: Decodable, T == T.DecodedType>(json: JSON, keys: [String]) -> Decoded<T?> {
  return .optional(json <| keys)
}

// MARK: Arrays

// Pull array from JSON
public func <|| <T where T: Decodable, T == T.DecodedType>(json: JSON, key: String) -> Decoded<[T]> {
  return json <|| [key]
}

// Pull optional array from JSON
public func <||? <T where T: Decodable, T == T.DecodedType>(json: JSON, key: String) -> Decoded<[T]?> {
  return .optional(json <|| [key])
}

// Pull embedded array from JSON
public func <|| <T where T: Decodable, T == T.DecodedType>(json: JSON, keys: [String]) -> Decoded<[T]> {
  return flatReduce(keys, initial: json, combine: decodedJSON) >>- Trray<T>.decode
}

// Pull embedded optional array from JSON
public func <||? <T where T: Decodable, T == T.DecodedType>(json: JSON, keys: [String]) -> Decoded<[T]?> {
  return .optional(json <|| keys)
}
