// MARK: Monadic Operators for the Decoded type

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

/**
  apply a `Decoded` function to a `Decoded` value

  - If the function is a failing case (`.TypeMismatch`, `.MissingKey`), this will return the function's value
  - If the function is a `.Success` case and the value is a failure case, this will return the value
  - If both self and the function are `.Success`, the function will be applied to the unwrapped value

  - parameter f: A `Decoded` transformation function from type `T` to type `U`
  - parameter x: A value of type `Decoded<T>`

  - returns: A value of type `Decoded<U>`
*/
public func <*> <T, U>(f: Decoded<T -> U>, x: Decoded<T>) -> Decoded<U> {
  return x.apply(f)
}

// MARK: Alternative operator

/**
  return the left `Decoded` value if it is `.Success`, otherwise return the right side

  - If the left hand side is successful, this will return the left hand side
  - If the left hand side is unsuccesful, this will return the right hand side

  - parameter lhs: A value of type `Decoded<T>`
  - parameter rhs: A value of type `Decoded<T>`

  - returns: A value of type `Decoded<T>`
*/

infix operator <|> { associativity left precedence 140 }

public func <|><T>(lhs: Decoded<T>, rhs: Decoded<T>) -> Decoded<T> {
  if case .Success = lhs {
    return lhs
  }
  return rhs
}

// MARK: Failure coalescing operator

/**
  return the unwrapped value of the `Decoded` value on the left if it is `.Success`, otherwise return the default on the right

  - If the left hand side is successful, this will return the unwrapped value from the left hand side argument
  - If the left hand side is unsuccesful, this will return the default value on the right hand side

  - parameter lhs: A value of type `Decoded<T>`
  - parameter rhs: An autoclosure returning a value of type `T`

  - returns: A value of type `T`
*/

public func ?? <T>(lhs: Decoded<T>, @autoclosure rhs: () -> T) -> T {
  switch lhs {
  case let .Success(x): return x
  case .Failure: return rhs()
  }
}
