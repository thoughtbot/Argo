public func catDecoded<T>(xs: [Decoded<T>]) -> [T] {
  var accum: [T] = []
  accum.reserveCapacity(xs.count)

  for case let .Success(value) in xs {
    accum.append(value)
  }

  return accum
}

public func catDecoded<T>(xs: [String: Decoded<T>]) -> [String: T] {
  var accum = Dictionary<String, T>(minimumCapacity: xs.count)

  for (key, x) in xs {
    if case let .Success(value) = x { accum[key] = value }
  }

  return accum
}
