public extension Decodable where Self.DecodedType == Self, Self: RawRepresentable, Self.RawValue == String {
  // Work around beta 6 bug where types cannot be deduced properly:
  private typealias Stringish = Self.DecodedType
  public static func decode(json: JSON) -> Decoded<Self> {
    switch json {
    case .String(let string):
      let res = self.init(rawValue: string)
      let dec = Decoded<Stringish>.fromOptional(res)
      return dec
    default:
      return Decoded.TypeMismatch("Attempted to decode \(json) into \(self), but needed a String")
    }
  }
}

public extension Decodable where Self.DecodedType == Self, Self: RawRepresentable, Self.RawValue == NSNumber {
  // Work around beta 6 bug where types cannot be deduced properly:
  private typealias Intish = Self.DecodedType
  public static func decode(json: JSON) -> Decoded<Self> {
    switch json {
    case .Number(let number):
      let res = self.init(rawValue: number)
      let dec = Decoded<Intish>.fromOptional(res)
      return dec
    default:
      return Decoded.TypeMismatch("Attempted to decode \(json) into \(self), but needed an Int")
    }
  }
}

