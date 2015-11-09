// pure merge for Dictionaries
public func + <T, U>(var lhs: [T: U], rhs: [T: U]) -> [T: U] {
  for (key, val) in rhs {
    lhs[key] = val
  }

  return lhs
}

extension Dictionary {
  public func map<T>(@noescape f: Value -> T) -> [Key: T] {
    return self.reduce([:]) { $0 + [$1.0: f($1.1)] }
  }
}

public func <^> <T, U, V>(@noescape f: T -> U, x: [V: T]) -> [V: U] {
  return x.map(f)
}
