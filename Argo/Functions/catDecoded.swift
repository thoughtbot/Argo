public func catDecoded<T>(xs: [Decoded<T>]) -> [T] {
  return xs.reduce([]) { accum, elem in
    elem.map { accum + [$0] } ?? accum
  }
}

public func catDecoded<T>(xs: [String: Decoded<T>]) -> [String: T] {
  return xs.reduce([:]) { accum, elem in
    elem.1.map { accum + [elem.0: $0] } ?? accum
  }
}
