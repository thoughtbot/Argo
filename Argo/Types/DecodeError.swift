/// Possible decoding failure reasons.
public enum DecodeError: Error {
  /// The type existing at the key didn't match the type being requested.
  case typeMismatch(expected: String, actual: String)

  /// The key did not exist in the JSON.
  case missingKey(String)

  /// A custom error case for adding explicit failure info.
  case custom(String)
}

extension DecodeError: CustomStringConvertible {
  public var description: String {
    switch self {
    case let .typeMismatch(expected, actual): return "TypeMismatch(Expected \(expected), got \(actual))"
    case let .missingKey(s): return "MissingKey(\(s))"
    case let .custom(s): return "Custom(\(s))"
    }
  }
}

extension DecodeError: Hashable {
  public var hashValue: Int {
    switch self {
    case let .typeMismatch(expected: expected, actual: actual):
      return expected.hashValue ^ actual.hashValue
    case let .missingKey(string):
      return string.hashValue
    case let .custom(string):
      return string.hashValue
    }
  }
}

public func == (lhs: DecodeError, rhs: DecodeError) -> Bool {
  switch (lhs, rhs) {
  case let (.typeMismatch(expected: expected1, actual: actual1), .typeMismatch(expected: expected2, actual: actual2)):
    return expected1 == expected2 && actual1 == actual2

  case let (.missingKey(string1), .missingKey(string2)):
    return string1 == string2

  case let (.custom(string1), .custom(string2)):
    return string1 == string2

  default:
    return false
  }
}
