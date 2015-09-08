public func sequence<T>(xs: [Decoded<T>]) -> Decoded<[T]> {
  return xs.reduce(pure([])) { accum, elem in
    curry(+) <^> accum <*> ({ [$0] } <^> elem)
  }
}

public func sequence<T>(xs: [String: Decoded<T>]) -> Decoded<[String: T]> {
  return xs.reduce(pure([:])) { accum, elem in
    curry(+) <^> accum <*> ({ [elem.0: $0] } <^> elem.1)
  }
}
