// pure merge for Dictionaries
func + <T, U>(var lhs: [T: U], rhs: [T: U]) -> [T: U] {
  for (key, val) in rhs {
    lhs[key] = val
  }

  return lhs
}

extension Dictionary {
  func map<T>(f: Value -> T) -> [Key: T] {
    return self.reduce([:]) { $0 + [$1.0: f($1.1)] }
  }
}

func <^> <T, U, V>(f: T -> U, x: [V: T]) -> [V: U] {
  return x.map(f)
}
