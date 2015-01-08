import Runes

func sequence<T>(xs: [T?]) -> [T]? {
  return reduce(xs, []) { accum, elem in
    return curry(+) <^> accum <*> (pure <^> elem)
  }
}
