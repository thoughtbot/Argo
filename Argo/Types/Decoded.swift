import Box

public enum Decoded<T> {
  case Success(Box<T>)
  case TypeMismatch(String)
  case MissingKey(String)

  public var value: T? {
    switch self {
    case let .Success(box): return box.value
    default: return .None
    }
  }

  public static func optional<A>(p: Decoded<A>) -> Decoded<A?> {
    switch p {
    case let .Success(box): return .Success(Box(.Some(box.value)))
    case let .MissingKey(string): return .Success(Box(.None))
    case let .TypeMismatch(string): return .TypeMismatch(string)
    }
  }
}
