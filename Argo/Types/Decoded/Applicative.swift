/**
  apply a `Decoded` function to a `Decoded` value

  - If the function is a failing case (`.TypeMismatch`, `.MissingKey`), this will return the function's value
  - If the function is a `.Success` case and the value is a failure case, this will return the value
  - If both self and the function are `.Success`, the function will be applied to the unwrapped value

  - parameter f: A `Decoded` transformation function from type `T` to type `U`
  - parameter a: A value of type `Decoded<T>`

  - returns: A value of type `Decoded<U>`
*/
public func <*> <T, U>(f: Decoded<T -> U>, x: Decoded<T>) -> Decoded<U> {
  return x.apply(f)
}

public func pure<T>(x: T) -> Decoded<T> {
  return .Success(x)
}

public extension Decoded {
  func apply<U>(f: Decoded<T -> U>) -> Decoded<U> {
    switch f {
    case let .Success(function): return self.map(function)
    case let .Failure(error): return .Failure(error)
    }
  }
}
