/**
  flatMap a function over a `Decoded` value (right associative)

  - If the value is `.Failure`, the function will not be evaluated and this
    will return `.Failure`
  - If the value is `.Success`, the function will be applied to the unwrapped value

  - parameter x: A value of type `Decoded<T>`
  - parameter f: A transformation function from type `T` to type `Decoded<U>`

  - returns: A value of type `Decoded<U>`
*/
public func >>- <T, U>(x: Decoded<T>, @noescape f: T -> Decoded<U>) -> Decoded<U> {
  return x.flatMap(f)
}

public extension Decoded {
  /**
    flatMap a function over self

    - If the value is `.Failure`, the function will not be evaluated and this
      will return `.Failure`
    - If the value is `.Success`, the function will be applied to the unwrapped value

    - parameter f: A transformation function from type `T` to type `Decoded<U>`

    - returns: A value of type `Decoded<U>`
  */
  func flatMap<U>(@noescape f: T -> Decoded<U>) -> Decoded<U> {
    switch self {
    case let .Success(value): return f(value)
    case let .Failure(error): return .Failure(error)
    }
  }
}
