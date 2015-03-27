import Box
import Runes

public enum Decoded<T> {
  case Success(Box<T>)
  case TypeMismatch(String)
  case MissingKey(String)

  public var value: T? {
    switch self {
    case let .Success(box): return box.value
    default: return .None
    }
  }
}

public extension Decoded {
  static func optional<T>(x: Decoded<T>) -> Decoded<T?> {
    switch x {
    case let .Success(box): return .Success(Box(.Some(box.value)))
    case let .MissingKey(string): return .Success(Box(.None))
    case let .TypeMismatch(string): return .TypeMismatch(string)
    }
  }

  static func fromOptional<T>(x: T?) -> Decoded<T> {
    switch x {
    case let .Some(value): return .Success(Box(value))
    case .None: return .TypeMismatch("Expected .Some(\(T.self)), got .None")
    }
  }
}

public extension Decoded {
  func map<U>(f: T -> U) -> Decoded<U> {
    switch self {
    case let .Success(box): return .Success(Box(f(box.value)))
    case let .MissingKey(string): return .MissingKey(string)
    case let .TypeMismatch(string): return .TypeMismatch(string)
    }
  }

  func apply<U>(f: Decoded<T -> U>) -> Decoded<U> {
    switch f {
    case let .Success(box): return box.value <^> self
    case let .MissingKey(string): return .MissingKey(string)
    case let .TypeMismatch(string): return .TypeMismatch(string)
    }
  }

  func flatMap<U>(f: T -> Decoded<U>) -> Decoded<U> {
    switch self {
    case let .Success(box): return f(box.value)
    case let .MissingKey(string): return .MissingKey(string)
    case let .TypeMismatch(string): return .TypeMismatch(string)
    }
  }
}

public func pure<A>(a: A) -> Decoded<A> {
  return .Success(Box(a))
}

// MARK: Monadic Operators

public func >>-<A, B>(a: Decoded<A>, f: A -> Decoded<B>) -> Decoded<B> {
  return a.flatMap(f)
}

public func <^><A, B>(f: A -> B, a: Decoded<A>) -> Decoded<B> {
  return a.map(f)
}

public func <*><A, B>(f: Decoded<A -> B>, a: Decoded<A>) -> Decoded<B> {
  return a.apply(f)
}
