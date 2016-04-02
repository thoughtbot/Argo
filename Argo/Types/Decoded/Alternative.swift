infix operator <|> { associativity left precedence 140 }

/**
  Return the left `Decoded` value if it is `.Success`, otherwise return the
  default value on the right.

  - If the left hand side is `.Success`, this will return the argument on the
    left hand side.
  - If the left hand side is `.Failure`, this will return the argument on the
    right hand side.

  - parameter lhs: A value of type `Decoded<T>`
  - parameter rhs: A value of type `Decoded<T>`

  - returns: A value of type `Decoded<T>`
*/
public func <|> <T>(lhs: Decoded<T>, @autoclosure rhs: () -> Decoded<T>) -> Decoded<T> {
  return lhs.or(rhs)
}

public extension Decoded {
  /**
    Return `self` if it is `.Success`, otherwise return the provided default
    value.

    - If `self` is `.Success`, this will return `self`.
    - If `self` is `.Failure`, this will return the default.

    - parameter other: A value of type `Decoded<T>`

    - returns: A value of type `Decoded<T>`
  */
  func or(@autoclosure other: () -> Decoded<T>) -> Decoded<T> {
    switch self {
      case .Success: return self
      case .Failure: return other()
    }
  }
}
