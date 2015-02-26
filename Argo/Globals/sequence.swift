import Runes

func sequence<T>(xs: [Decoded<T>]) -> Decoded<[T]> {
  return reduce(xs, pure([])) { accum, elem in
    return curry(+) <^> accum <*> (pure <^> elem)
  }
}

func sequence<T>(xs: [String: Decoded<T>]) -> Decoded<[String: T]> {
  return reduce(xs, pure([:])) { accum, elem in
    return curry(+) <^> accum <*> ({ [elem.0: $0] } <^> elem.1)
  }
}
