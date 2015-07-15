public enum Decoded<T> {
  case Success(T)
  case TypeMismatch(String)
  case MissingKey(String)

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
    case .MissingKey: return .Success(.None)
    case let .TypeMismatch(string): return .TypeMismatch(string)
    }
  }

  static func fromOptional<T>(x: T?) -> Decoded<T> {
    switch x {
    case let .Some(value): return .Success(value)
    case .None: return .TypeMismatch("Expected .Some(\(T.self)), got .None")
    }
  }
}

extension Decoded: CustomStringConvertible {
  public var description: String {
    switch self {
    case let .Success(x): return "Success(\(x))"
    case let .TypeMismatch(s): return "TypeMismatch(\(s))"
    case let .MissingKey(s): return "MissingKey(\(s))"
    }
  }
}

public extension Decoded {
  func map<U>(f: T -> U) -> Decoded<U> {
    switch self {
    case let .Success(value): return .Success(f(value))
    case let .MissingKey(string): return .MissingKey(string)
    case let .TypeMismatch(string): return .TypeMismatch(string)
    }
  }

  func apply<U>(f: Decoded<T -> U>) -> Decoded<U> {
    switch f {
    case let .Success(value): return value <^> self
    case let .MissingKey(string): return .MissingKey(string)
    case let .TypeMismatch(string): return .TypeMismatch(string)
    }
  }

  func flatMap<U>(f: T -> Decoded<U>) -> Decoded<U> {
    switch self {
    case let .Success(value): return f(value)
    case let .MissingKey(string): return .MissingKey(string)
    case let .TypeMismatch(string): return .TypeMismatch(string)
    }
  }
}

public func pure<A>(a: A) -> Decoded<A> {
  return .Success(a)
}

// MARK: Monadic Operators

public func >>- <A, B>(a: Decoded<A>, f: A -> Decoded<B>) -> Decoded<B> {
  return a.flatMap(f)
}

public func <^> <A, B>(f: A -> B, a: Decoded<A>) -> Decoded<B> {
  return a.map(f)
}

public func <*> <A, B>(f: Decoded<A -> B>, a: Decoded<A>) -> Decoded<B> {
  return a.apply(f)
}
