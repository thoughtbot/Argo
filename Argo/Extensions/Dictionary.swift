extension Dictionary {
  func mapThrows<A>(f: Value throws -> A) throws -> [Key: A] {
    var output: [Key: A] = [:]
    for (key, value) in self {
      output[key] = try f(value)
    }
    return output
  }
}
