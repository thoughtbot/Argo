public enum DecodeError: ErrorType {
  case TypeMismatch(expected: String, actual: String)
  case MissingKey(String)
  case Custom(String)
}

extension DecodeError: CustomStringConvertible {
  public var description: String {
    switch self {
    case let .TypeMismatch(expected, actual): return "TypeMismatch(Expected \(expected), got \(actual))"
    case let .MissingKey(s): return "MissingKey(\(s))"
    case let .Custom(s): return "Custom(\(s))"
    }
  }
}
