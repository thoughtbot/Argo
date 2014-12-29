public func pure<A>(a: A) -> A? {
  return .Some(a)
}

public func pure<A>(a: A) -> [A] {
  return [a]
}
