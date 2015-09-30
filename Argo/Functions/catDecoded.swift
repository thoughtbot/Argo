public func catDecoded<T>(xs: [Decoded<T>]) -> [T] {
  return xs.reduce([]) { accum, elem in
    return elem.map { accum + [$0] } ?? accum
  }
}
