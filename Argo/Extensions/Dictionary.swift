// pure merge for Dictionaries
func + <T, U>(var lhs: [T: U], rhs: [T: U]) -> [T: U] {
  for (key, val) in rhs {
    lhs[key] = val
  }

  return lhs
}

extension Dictionary {
  func map<T>(@noescape f: Value -> T) -> [Key: T] {
    var accum = Dictionary<Key, T>(minimumCapacity: self.count)

    for (key, value) in self {
      accum[key] = f(value)
    }

    return accum
  }
}

func <^> <T, U, V>(@noescape f: T -> U, x: [V: T]) -> [V: U] {
  return x.map(f)
}
