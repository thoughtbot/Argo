public func catDecoded<T>(xs: [Decoded<T>]) -> [T] {
  var accum: [T] = []
  accum.reserveCapacity(xs.count)

  for x in xs {
    switch x {
    case let .Success(value): accum.append(value)
    case .Failure: continue
    }
  }

  return accum
}

public func catDecoded<T>(xs: [String: Decoded<T>]) -> [String: T] {
  var accum = Dictionary<String, T>(minimumCapacity: xs.count)

  for (key, x) in xs {
    switch x {
    case let .Success(value): accum[key] = value
    case .Failure: continue
    }
  }

  return accum
}
