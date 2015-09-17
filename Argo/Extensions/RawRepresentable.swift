public extension Decodable where Self.DecodedType == Self, Self: RawRepresentable, Self.RawValue == String {
  static func decode(json: JSON) -> Decoded<Self> {
    switch json {
    case let .String(s): return .fromOptional(self.init(rawValue: s))
    default: return .typeMismatch("String", actual: json)
    }
  }
}

public extension Decodable where Self.DecodedType == Self, Self: RawRepresentable, Self.RawValue == Int {
  static func decode(json: JSON) -> Decoded<Self> {
    switch json {
    case let .Number(n): return .fromOptional(self.init(rawValue: n as Int))
    default: return .typeMismatch("Int", actual: json)
    }
  }
}
