/**
  apply a `Decoded` function to a `Decoded` value

  - If the function is a `.Failure` case, this will return the function's
    failure
  - If the function is a `.Success` case and the value is a `.Failure` case,
    this will return the value's failure
  - If both the value and the function are `.Success`, the function will be
    applied to the unwrapped value

  - parameter f: A `Decoded` transformation function from type `T` to type `U`
  - parameter a: A value of type `Decoded<T>`

  - returns: A value of type `Decoded<U>`
*/
public func <*> <T, U>(f: Decoded<T -> U>, x: Decoded<T>) -> Decoded<U> {
  return x.apply(f)
}

/**
  Wrap a value in the minimal context of `.Success`

  - parameter x: Any value

  - returns: The provided value wrapped in `.Success`
*/
public func pure<T>(x: T) -> Decoded<T> {
  return .Success(x)
}

public extension Decoded {
  /**
    apply a `Decoded` function to self

    - If the function is a `.Failure` case, this will return the function's
      failure
    - If the function is a `.Success` case and self is a `.Failure` case,
      this will return self's failure
    - If both self and the function are `.Success`, the function will be
      applied to the unwrapped value of self

    - parameter f: A `Decoded` transformation function from type `T` to type `U`

    - returns: A value of type `Decoded<U>`
  */
  func apply<U>(f: Decoded<T -> U>) -> Decoded<U> {
    switch f {
    case let .Success(function): return self.map(function)
    case let .Failure(error): return .Failure(error)
    }
  }
}
