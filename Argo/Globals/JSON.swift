import Foundation

extension String: JSONDecodable {
  public static var decoder: JSONValue -> String? {
    return { $0.value() }
  }
}

extension Int: JSONDecodable {
  public static var decoder: JSONValue -> Int? {
    return { $0.value() }
  }
}

extension Double: JSONDecodable {
  public static var decoder: JSONValue -> Double? {
    return { $0.value() }
  }
}

extension Bool: JSONDecodable {
  public static var decoder: JSONValue -> Bool? {
    return { $0.value() }
  }
}
