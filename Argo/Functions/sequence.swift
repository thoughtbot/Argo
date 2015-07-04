import Runes

func sequence<T>(xs: [Decoded<T>]) -> Decoded<[T]> {
  return reduce(xs, pure([])) { accum, elem in
    curry(+) <^> accum <*> (pure <^> elem)
  }
}

func sequence<T>(xs: [String: Decoded<T>]) -> Decoded<[String: T]> {
  return reduce(xs, pure([:])) { accum, elem in
    curry(+) <^> accum <*> ({ [elem.0: $0] } <^> elem.1)
  }
}

func sequenceOptionals<T>(xs: [Decoded<T>]) -> Decoded<[T]> {
  return reduce(xs, pure([])) { accum, elem in
    switch elem {
    case .Success(_): return curry(+) <^> accum <*> (pure <^> elem)
    default: return accum
    }
  }
}