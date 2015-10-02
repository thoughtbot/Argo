public enum Decoded<T> {
  case Success(T)
  case Failure(DecodeError)

  public var value: T? {
    switch self {
    case let .Success(value): return value
    default: return .None
    }
  }
  
  public var error: DecodeError? {
    switch self {
    case let .Failure(error): return error
    default: return .None
    }
  }
}

public extension Decoded {
  static func optional<T>(x: Decoded<T>) -> Decoded<T?> {
    switch x {
    case let .Success(value): return .Success(.Some(value))
    case .Failure(.MissingKey): return .Success(.None)
    case let .Failure(.TypeMismatch(x)): return .Failure(.TypeMismatch(x))
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
  static func typeMismatch<T, U: CustomStringConvertible>(expected: String, actual: U) -> Decoded<T> {
    return .typeMismatch(expected, actual: "\(actual)")
  }

  static func typeMismatch<T>(expected: String, actual: String) -> Decoded<T> {
    return .Failure(.TypeMismatch(expected: expected, actual: actual))
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
