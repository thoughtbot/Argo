// Pull value from JSON
prefix public func <|<A: JSONDecodable>(key: String) -> JSONValue -> A? {
  return <|[key]
}

// Pull embedded value from JSON
prefix public func <|<A: JSONDecodable>(keys: [String]) -> JSONValue -> A? {
  return { keys.reduce($0) { $0?[$1] } >>- A.decoder }
}

// Pull array from JSON
prefix public func <||<A: JSONDecodable>(key: String) -> JSONValue -> [A]? {
  return <||[key]
}

// Pull embedded array from JSON
prefix public func <||<A: JSONDecodable>(keys: [String]) -> JSONValue -> [A]? {
  return { keys.reduce($0) { $0?[$1] } >>- JSONValue.map }
}

// Pull optional value from JSON
prefix public func <|*<A: JSONDecodable>(key: String) -> JSONValue -> A?? {
  return <|*[key]
}

// Pull embedded optional value from JSON
prefix public func <|*<A: JSONDecodable>(keys: [String]) -> JSONValue -> A?? {
  return { pure(keys.reduce($0) { $0?[$1] } >>- A.decoder) }
}

// Pull optional array from JSON
prefix public func <||*<A: JSONDecodable>(key: String) -> JSONValue -> [A]?? {
  return <||*[key]
}

// Pull embedded optional array from JSON
prefix public func <||*<A: JSONDecodable>(keys: [String]) -> JSONValue -> [A]?? {
  return { pure(keys.reduce($0) { $0?[$1] } >>- JSONValue.map) }
}
