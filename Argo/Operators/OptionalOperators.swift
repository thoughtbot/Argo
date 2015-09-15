// MARK: Values

// Pull value from JSON
public func <| <A where A: Decodable, A == A.DecodedType>(json: JSON, key: String) -> A? {
  return json <| [key]
}

// Pull optional value from JSON
public func <|? <A where A: Decodable, A == A.DecodedType>(json: JSON, key: String) -> A?? {
  return json <| [key]
}

// Pull embedded value from JSON
public func <| <A where A: Decodable, A == A.DecodedType>(json: JSON, keys: [String]) -> A? {
  return (json <| keys).value
}

// Pull embedded optional value from JSON
public func <|? <A where A: Decodable, A == A.DecodedType>(json: JSON, keys: [String]) -> A?? {
  return (json <|? keys).value
}

// MARK: Arrays

// Pull array from JSON
public func <|| <A where A: Decodable, A == A.DecodedType>(json: JSON, key: String) -> [A]? {
  return json <|| [key]
}

// Pull optional array from JSON
public func <||? <A where A: Decodable, A == A.DecodedType>(json: JSON, key: String) -> [A]?? {
  return json <||? [key]
}

// Pull embedded array from JSON
public func <|| <A where A: Decodable, A == A.DecodedType>(json: JSON, keys: [String]) -> [A]? {
  return (json <|| keys).value
}

// Pull embedded optional array from JSON
public func <||? <A where A: Decodable, A == A.DecodedType>(json: JSON, keys: [String]) -> [A]?? {
  return (json <||? keys).value
}
