import Foundation

extension String: JSONDecodable {
  public static func decode(j: JSONValue) -> String? {
    return j.value()
  }
}

extension Int: JSONDecodable {
  public static func decode(j: JSONValue) -> Int? {
    return j.value()
  }
}

extension Double: JSONDecodable {
  public static func decode(j: JSONValue) -> Double? {
    return j.value()
  }
}

extension Bool: JSONDecodable {
  public static func decode(j: JSONValue) -> Bool? {
    return j.value()
  }
}

extension Float: JSONDecodable {
  public static func decode(j: JSONValue) -> Float? {
    return j.value()
  }
}
