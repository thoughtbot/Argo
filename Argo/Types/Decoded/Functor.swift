/**
  map a function over a `Decoded` value

  - If the value is is a failing case (`.TypeMismatch`, `.MissingKey`), the function will not be evaluated and this will return the value
  - If the value is `.Success`, the function will be applied to the unwrapped value

  - parameter f: A transformation function from type `T` to type `U`
  - parameter x: A value of type `Decoded<T>`

  - returns: A value of type `Decoded<U>`
*/
public func <^> <T, U>(f: T -> U, x: Decoded<T>) -> Decoded<U> {
  return x.map(f)
}

public extension Decoded {
  func map<U>(f: T -> U) -> Decoded<U> {
    switch self {
    case let .Success(value): return .Success(f(value))
    case let .Failure(error): return .Failure(error)
    }
  }
}
