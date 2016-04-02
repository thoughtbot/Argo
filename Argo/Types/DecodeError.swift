/// Possible decoding failure reasons.
public enum DecodeError: ErrorType {
  /// The type existing at the key didn't match the type being requested.
  case TypeMismatch(expected: String, actual: String)

  /// The key did not exist in the JSON.
  case MissingKey(String)

  /// A custom error case for adding explicit failure info.
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

extension DecodeError: Hashable {
  public var hashValue: Int {
    switch self {
    case let .TypeMismatch(expected: expected, actual: actual):
      return expected.hashValue ^ actual.hashValue
    case let .MissingKey(string):
      return string.hashValue
    case let .Custom(string):
      return string.hashValue
    }
  }
}

public func == (lhs: DecodeError, rhs: DecodeError) -> Bool {
  switch (lhs, rhs) {
  case let (.TypeMismatch(expected: expected1, actual: actual1), .TypeMismatch(expected: expected2, actual: actual2)):
    return expected1 == expected2 && actual1 == actual2

  case let (.MissingKey(string1), .MissingKey(string2)):
    return string1 == string2

  case let (.Custom(string1), .Custom(string2)):
    return string1 == string2

  default:
    return false
  }
}
