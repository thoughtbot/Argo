// MARK: Values

// Pull value from JSON
public func <| <T where T: Decodable, T == T.DecodedType>(json: JSON, key: String) -> T? {
  return json <| [key]
}

// Pull optional value from JSON
public func <|? <T where T: Decodable, T == T.DecodedType>(json: JSON, key: String) -> T?? {
  return json <| [key]
}

// Pull embedded value from JSON
public func <| <T where T: Decodable, T == T.DecodedType>(json: JSON, keys: [String]) -> T? {
  return (json <| keys).value
}

// Pull embedded optional value from JSON
public func <|? <T where T: Decodable, T == T.DecodedType>(json: JSON, keys: [String]) -> T?? {
  return (json <|? keys).value
}

// MARK: Arrays

// Pull array from JSON
public func <|| <T where T: Decodable, T == T.DecodedType>(json: JSON, key: String) -> [T]? {
  return json <|| [key]
}

// Pull optional array from JSON
public func <||? <T where T: Decodable, T == T.DecodedType>(json: JSON, key: String) -> [T]?? {
  return json <||? [key]
}

// Pull embedded array from JSON
public func <|| <T where T: Decodable, T == T.DecodedType>(json: JSON, keys: [String]) -> [T]? {
  return (json <|| keys).value
}

// Pull embedded optional array from JSON
public func <||? <T where T: Decodable, T == T.DecodedType>(json: JSON, keys: [String]) -> [T]?? {
  return (json <||? keys).value
}
