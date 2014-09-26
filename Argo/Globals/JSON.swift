import Foundation

public typealias JSON = AnyObject
public typealias JSONObject = [String:JSON]
public typealias JSONArray = [JSON]

public func _JSONParse<A: JSONDecodable>(json: JSON) -> A? {
  return A.decode(json)
}

public func _JSONParse<A>(json: JSON) -> A? {
  return json as? A
}

extension String: JSONDecodable {
  public static func decode(json: JSON) -> String? {
    return json as? String
  }
}

extension Int: JSONDecodable {
  public static func decode(json: JSON) -> Int? {
    return json as? Int
  }
}

extension Double: JSONDecodable {
  public static func decode(json: JSON) -> Double? {
    return json as? Double
  }
}

extension Bool: JSONDecodable {
  public static func decode(json: JSON) -> Bool? {
    return json as? Bool
  }
}
