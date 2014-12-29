// MARK: Values

// Pull embedded value from JSON
prefix public func <|<A: JSONDecodable>(keys: [String]) -> JSONValue -> A? {
  return { keys.reduce($0) { $0?[$1] } >>- A.decoder }
}

// Pull value from JSON
prefix public func <|<A: JSONDecodable>(key: String) -> JSONValue -> A? {
  return <|[key]
}

// Pull optional value from JSON
prefix public func <|?<A: JSONDecodable>(key: String) -> JSONValue -> A?? {
  return <|?[key]
}

// Pull embedded optional value from JSON
prefix public func <|?<A: JSONDecodable>(keys: [String]) -> JSONValue -> A?? {
  return { pure((<|keys)($0)) }
}

// MARK: Arrays

// Pull embedded array from JSON
prefix public func <||<A: JSONDecodable>(keys: [String]) -> JSONValue -> [A]? {
  return { keys.reduce($0) { $0?[$1] } >>- JSONValue.map }
}

// Pull array from JSON
prefix public func <||<A: JSONDecodable>(key: String) -> JSONValue -> [A]? {
  return <||[key]
}

// Pull optional array from JSON
prefix public func <||?<A: JSONDecodable>(key: String) -> JSONValue -> [A]?? {
  return <||?[key]
}

// Pull embedded optional array from JSON
prefix public func <||?<A: JSONDecodable>(keys: [String]) -> JSONValue -> [A]?? {
  return { pure((<||keys)($0)) }
}
