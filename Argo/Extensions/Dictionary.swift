extension Dictionary {
  func map<A>(f: Value throws -> A) rethrows -> [Key: A] {
    var output: [Key: A] = [:]
    for (key, value) in self {
      output[key] = try f(value)
    }
    return output
  }
}
