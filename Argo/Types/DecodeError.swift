/// Possible decoding failure reasons
public enum DecodeError: ErrorType {

  /// The type existing at the key didn't match the type being requested
  case TypeMismatch(expected: String, actual: String)

  /// The key did not exist in the JSON
  case MissingKey(String)

  /// A custom error case for adding explicit failure info
  case Custom(String)
}

extension DecodeError: CustomStringConvertible {
  /// String representations of `DecodeError`
  public var description: String {
    switch self {
    case let .TypeMismatch(expected, actual): return "TypeMismatch(Expected \(expected), got \(actual))"
    case let .MissingKey(s): return "MissingKey(\(s))"
    case let .Custom(s): return "Custom(\(s))"
    }
  }
}
