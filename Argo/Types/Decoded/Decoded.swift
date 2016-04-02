/// The result of a failable decoding operation.
public enum Decoded<T> {
  case Success(T)
  case Failure(DecodeError)
}

public extension Decoded {
  /**
    Get the unwrapped value as an `Optional`.

    - returns: The unwrapped value if it exists, otherwise `.None`
  */
  var value: T? {
    switch self {
    case let .Success(value): return value
    case .Failure: return .None
    }
  }

  /**
    Get the error value as an `Optional`.

    - returns: The unwrapped error if it exists, otherwise `.None`
  */
  var error: DecodeError? {
    switch self {
    case .Success: return .None
    case let .Failure(error): return error
    }
  }
}

public extension Decoded {
  /**
    Convert a `Decoded` type into a `Decoded` `Optional` type.

    This is useful for when a decode operation should be allowed to fail, such
    as when decoding an optional property.

    It only returns a `.Failure` case if the error is `.TypeMismatch` or
    `.Custom`. If the error was `.MissingKey`, it converts the failure into
    `.Success(.None)`.

    - parameter x: A `Decoded` type

    - returns: The `Decoded` type with a `.TypeMismatch` failure converted to
               `.Success(.None)`
  */
  static func optional<T>(x: Decoded<T>) -> Decoded<T?> {
    switch x {
    case let .Success(value): return .Success(.Some(value))
    case .Failure(.MissingKey): return .Success(.None)
    case let .Failure(.TypeMismatch(expected, actual)):
      return .Failure(.TypeMismatch(expected: expected, actual: actual))
    case let .Failure(.Custom(x)): return .Failure(.Custom(x))
    }
  }

  /**
    Convert an `Optional` into a `Decoded` value.

    If the provided optional is `.Some`, this method extracts the value and
    wraps it in `.Success`. Otherwise, it returns a `.TypeMismatch` error.

    - returns: The provided `Optional` value transformed into a `Decoded` value
  */
  static func fromOptional<T>(x: T?) -> Decoded<T> {
    switch x {
    case let .Some(value): return .Success(value)
    case .None: return .typeMismatch(".Some(\(T.self))", actual: ".None")
    }
  }
}

public extension Decoded {
  /**
    Convenience function for creating `.TypeMismatch` errors.

    - parameter expected: A string describing the expected type
    - parameter actual: A string describing the actual type

    - returns: A `Decoded.Failure` with a `.TypeMismatch` error constructed
               from the provided `expected` and `actual` values
  */
  static func typeMismatch<T, U>(expected: String, actual: U) -> Decoded<T> {
    return .Failure(.TypeMismatch(expected: expected, actual: String(actual)))
  }

  /**
    Convenience function for creating `.MissingKey` errors.

    - parameter name: The name of the missing key

    - returns: A `Decoded.Failure` with a `.MissingKey` error constructed from
               the provided `name` value
  */
  static func missingKey<T>(name: String) -> Decoded<T> {
    return .Failure(.MissingKey(name))
  }

  /**
    Convenience function for creating `.Custom` errors

    - parameter message: The custom error message

    - returns: A `Decoded.Failure` with a `.Custom` error constructed from the
               provided `message` value
  */
  static func customError<T>(message: String) -> Decoded<T> {
    return .Failure(.Custom(message))
  }
}

extension Decoded: CustomStringConvertible {
  public var description: String {
    switch self {
    case let .Success(value): return "Success(\(value))"
    case let .Failure(error): return "Failure(\(error))"
    }
  }
}

public extension Decoded {
  /**
    Extract the `.Success` value or throw an error.

    This can be used to move from `Decoded` types into the world of `throws`.
    If the value exists, this will return it. Otherwise, it will throw the error
    information.

    - throws: `DecodeError` if `self` is `.Failure`

    - returns: The unwrapped value
  */
  func dematerialize() throws -> T {
    switch self {
    case let .Success(value): return value
    case let .Failure(error): throw error
    }
  }
}

/**
  Construct a `Decoded` type from a throwing function.

  This can be used to move from the world of `throws` into a `Decoded` type. If
  the function succeeds, it will wrap the returned value in a minimal context of
  `.Success`. Otherwise, it will return a custom error with the thrown error from
  the function.

  - parameter f: A function from `Void` to `T` that can `throw` an error

  - returns: A `Decoded` type representing the success or failure of the function
*/
public func materialize<T>(f: () throws -> T) -> Decoded<T> {
  do {
    return .Success(try f())
  } catch {
    return .customError("\(error)")
  }
}
