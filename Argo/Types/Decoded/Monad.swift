/**
  flatMap a function over a `Decoded` value (right associative)

  - If the value is a failing case (`.TypeMismatch`, `.MissingKey`), the function will not be evaluated and this will return the value
  - If the value is `.Success`, the function will be applied to the unwrapped value

  - parameter x: A value of type `Decoded<T>`
  - parameter f: A transformation function from type `T` to type `Decoded<U>`

  - returns: A value of type `Decoded<U>`
*/
public func >>- <T, U>(x: Decoded<T>, f: T -> Decoded<U>) -> Decoded<U> {
  return x.flatMap(f)
}

public extension Decoded {
  func flatMap<U>(f: T -> Decoded<U>) -> Decoded<U> {
    switch self {
    case let .Success(value): return f(value)
    case let .Failure(error): return .Failure(error)
    }
  }
}
