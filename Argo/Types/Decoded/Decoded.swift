public enum Decoded<T> {
  case Success(T)
  case Failure(DecodeError)
}

public extension Decoded {
  var value: T? {
    switch self {
    case let .Success(value): return value
    case .Failure: return .None
    }
  }

  var error: DecodeError? {
    switch self {
    case .Success: return .None
    case let .Failure(error): return error
    }
  }
}

public extension Decoded {
  static func optional<T>(x: Decoded<T>) -> Decoded<T?> {
    switch x {
    case let .Success(value): return .Success(.Some(value))
    case .Failure(.MissingKey): return .Success(.None)
    case let .Failure(.TypeMismatch(expected, actual)):
      return .Failure(.TypeMismatch(expected: expected, actual: actual))
    case let .Failure(.Custom(x)): return .Failure(.Custom(x))
    }
  }

  static func fromOptional<T>(x: T?) -> Decoded<T> {
    switch x {
    case let .Some(value): return .Success(value)
    case .None: return .typeMismatch(".Some(\(T.self))", actual: ".None")
    }
  }
}

public extension Decoded {
  static func typeMismatch<T, U>(expected: String, actual: U) -> Decoded<T> {
    return .Failure(.TypeMismatch(expected: expected, actual: String(actual)))
  }

  static func missingKey<T>(name: String) -> Decoded<T> {
    return .Failure(.MissingKey(name))
  }

  static func customError<T>(message: String) -> Decoded<T> {
    return .Failure(.Custom(message))
  }
}

extension Decoded: CustomStringConvertible {
  public var description: String {
    switch self {
    case let .Success(value): return "Success(\(value))"
    case let .Failure(error): return "Failure(\(error))"
    }
  }
}

public extension Decoded {
  func dematerialize() throws -> T {
    switch self {
    case let .Success(value): return value
    case let .Failure(error): throw error
    }
  }
}

public func materialize<T>(f: () throws -> T) -> Decoded<T> {
  do {
    return .Success(try f())
  } catch {
    return .customError("\(error)")
  }
}
