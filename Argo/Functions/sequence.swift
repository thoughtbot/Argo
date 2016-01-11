public func sequence<T>(xs: [Decoded<T>]) -> Decoded<[T]> {
  var accum: [T] = []
  accum.reserveCapacity(xs.count)

  for elem in xs {
    switch elem {
    case let .Success(value):
      accum.append(value)
    case let .Failure(error):
      return .Failure(error)
    }
  }

  return pure(accum)
}

public func sequence<T>(xs: [String: Decoded<T>]) -> Decoded<[String: T]> {
  var accum: [String: T] = [:]

  for (key, value) in xs {
    switch value {
    case let .Success(unwrapped):
      accum[key] = unwrapped
    case let .Failure(error):
      return .Failure(error)
    }
  }

  return pure(accum)
}
