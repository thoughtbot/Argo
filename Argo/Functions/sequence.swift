import Runes

public func sequence<T>(xs: [Decoded<T>]) -> Decoded<[T]> {
  return reduce(xs, pure([])) { accum, elem in
    curry(+) <^> accum <*> (pure <^> elem)
  }
}

public func sequence<T>(xs: [String: Decoded<T>]) -> Decoded<[String: T]> {
  return reduce(xs, pure([:])) { accum, elem in
    curry(+) <^> accum <*> ({ [elem.0: $0] } <^> elem.1)
  }
}
