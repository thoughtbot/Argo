public enum DecodedError: ErrorType {
  case TypeMismatch(String)
  case MissingKey(String)
}

extension DecodedError: CustomStringConvertible {
  public var description: String {
    switch self {
    case let .TypeMismatch(s): return "TypeMismatch(\(s))"
    case let .MissingKey(s): return "MissingKey(\(s))"
    }
  }
}
