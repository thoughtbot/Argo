public func >>-<A, B>(a: A?, f: A -> B?) -> B? {
  switch a {
  case let .Some(x): return f(x)
  default: return .None
  }
}

public func <^><A, B>(f: A -> B, a: A?) -> B? {
  switch a {
  case let .Some(x): return f(x)
  default: return .None
  }
}

public func <*><A, B>(f: (A -> B)?, a: A?) -> B? {
  switch f {
  case let .Some(fx): return fx <^> a
  default: return .None
  }
}
