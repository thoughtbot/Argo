public extension Decodable where Self.DecodedType == Self, Self: RawRepresentable, Self.RawValue == String {
  static func decode(json: JSON) -> Decoded<Self> {
    switch json {
    case let .String(s): return self.init(rawValue: s).map(pure) ?? .typeMismatch("rawValue for \(self)", actual: json)
    default: return .typeMismatch("String", actual: json)
    }
  }
}

public extension Decodable where Self.DecodedType == Self, Self: RawRepresentable, Self.RawValue == Int {
  static func decode(json: JSON) -> Decoded<Self> {
    switch json {
    case let .Number(n): return self.init(rawValue: n as Int).map(pure) ?? .typeMismatch("rawValue for \(self)", actual: json)
    default: return .typeMismatch("Int", actual: json)
    }
  }
}
