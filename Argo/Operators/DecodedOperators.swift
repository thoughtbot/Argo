import Runes
import Box

public func >>-<A, B>(a: Decoded<A>, f: A -> Decoded<B>) -> Decoded<B> {
  switch a {
  case let .Success(box): return f(box.value)
  case let .MissingKey(string): return .MissingKey(string)
  case let .TypeMismatch(string): return .TypeMismatch(string)
  }
}

public func <^><A, B>(f: A -> B, a: Decoded<A>) -> Decoded<B> {
  switch a {
  case let .Success(box): return .Success(Box(f(box.value)))
  case let .MissingKey(string): return .MissingKey(string)
  case let .TypeMismatch(string): return .TypeMismatch(string)
  }
}

public func <*><A, B>(f: Decoded<A -> B>, a: Decoded<A>) -> Decoded<B> {
  switch f {
  case let .Success(box): return box.value <^> a
  case let .MissingKey(string): return .MissingKey(string)
  case let .TypeMismatch(string): return .TypeMismatch(string)
  }
}

public func pure<A>(a: A) -> Decoded<A> {
  return .Success(Box(a))
}
