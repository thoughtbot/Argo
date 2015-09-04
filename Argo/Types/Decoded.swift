public enum DecodeError: ErrorType {
  case TypeMismatch(String)
  case MissingKey(String)
}

extension DecodeError: CustomStringConvertible {
  public var description: String {
    switch self {
    case let .TypeMismatch(s): return "TypeMismatch(\(s))"
    case let .MissingKey(s): return "MissingKey(\(s))"
    }
  }
}

public enum Decoded<T> {
  case Success(T)
  case Failure(DecodeError)

  public var value: T? {
    switch self {
    case let .Success(value): return value
    default: return .None
    }
  }
}

public extension Decoded {
  static func optional<T>(x: Decoded<T>) -> Decoded<T?> {
    switch x {
    case let .Success(value): return .Success(.Some(value))
    case .Failure(.MissingKey): return .Success(.None)
    case let .Failure(.TypeMismatch(string)): return .Failure(.TypeMismatch(string))
    }
  }

  static func fromOptional<T>(x: T?) -> Decoded<T> {
    switch x {
    case let .Some(value): return .Success(value)
    case .None: return .Failure(.TypeMismatch("Expected .Some(\(T.self)), got .None"))
    }
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
  func map<U>(f: T -> U) -> Decoded<U> {
    switch self {
    case let .Success(value): return .Success(f(value))
    case let .Failure(error): return .Failure(error)
    }
  }

  func apply<U>(f: Decoded<T -> U>) -> Decoded<U> {
    switch f {
    case let .Success(function): return self.map(function)
    case let .Failure(error): return .Failure(error)
    }
  }

  func flatMap<U>(f: T -> Decoded<U>) -> Decoded<U> {
    switch self {
    case let .Success(value): return f(value)
    case let .Failure(error): return .Failure(error)
    }
  }
}

public func pure<A>(a: A) -> Decoded<A> {
  return .Success(a)
}
