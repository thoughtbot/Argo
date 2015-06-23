extension String: Decodable {
  public static func decode(j: JSON) throws -> String {
    switch j {
    case let .String(s): return s
    default: throw typeMismatch("String", forObject: j)
    }
  }
}

extension Int: Decodable {
  public static func decode(j: JSON) throws -> Int {
    switch j {
    case let .Number(n): return n as Int
    default: throw typeMismatch("Int", forObject: j)
    }
  }
}

extension Int64: Decodable {
  public static func decode(j: JSON) throws -> Int64 {
    switch j {
    case let .Number(n): return n.longLongValue
    default: throw typeMismatch("Int64", forObject: j)
    }
  }
}

extension Double: Decodable {
  public static func decode(j: JSON) throws -> Double {
    switch j {
    case let .Number(n): return n as Double
    default: throw typeMismatch("Double", forObject: j)
    }
  }
}

extension Bool: Decodable {
  public static func decode(j: JSON) throws -> Bool {
    switch j {
    case let .Number(n): return n as Bool
    default: throw typeMismatch("Bool", forObject: j)
    }
  }
}

extension Float: Decodable {
  public static func decode(j: JSON) throws -> Float {
    switch j {
    case let .Number(n): return n as Float
    default: throw typeMismatch("Float", forObject: j)
    }
  }
}

public func decodeArray<A where A: Decodable, A == A.DecodedType>(value: JSON) throws -> [A] {
  switch value {
  case let .Array(a): return a.map(A.decode)
  default: throw typeMismatch("Array", forObject: value)
  }
}

public func decodeObject<A where A: Decodable, A == A.DecodedType>(value: JSON) throws -> [String: A] {
  switch value {
  case let .Object(o): return o.map(A.decode)
  default: throw typeMismatch("Object", forObject: value)
  }
}

func decodedJSON(json: JSON, forKey key: String) throws -> JSON {
  switch json {
  case let .Object(o): do { return try guardNull(key, j: o[key] ?? .Null) }
  default: throw typeMismatch("Object", forObject: json)
  }
}

private func typeMismatch(expectedType: String, forObject object: JSON) -> DecodedError {
  return .TypeMismatch("\(object) is not a \(expectedType)")
}

private func guardNull(key: String, j: JSON) throws -> JSON {
  switch j {
  case .Null: throw DecodedError.MissingKey(key)
  default: return j
  }
}
