public func >>-<A, B>(a: A?, f: A -> B?) -> B? {
  if let x = a {
    return f(x)
  } else {
    return .None
  }
}

public func <^><A, B>(f: A -> B, a: A?) -> B? {
  if let x = a {
    return f(x)
  } else {
    return .None
  }
}

public func <*><A, B>(f: (A -> B)?, a: A?) -> B? {
  if let fx = f {
    return fx <^> a
  }
  return .None
}

public func <^><A, B, J>(f: A -> B, a: J -> A?) -> J -> B? {
  return {  f <^> a($0) }
}

public func <*><A, B, J>(f: J -> (A -> B)?, a: J -> A?) -> J -> B? {
  return { f($0) <*> a($0) }
}
