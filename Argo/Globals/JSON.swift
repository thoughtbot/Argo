import Foundation

//MARK: JSONDecodable
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

//MARK: JSONEncodable
extension String: JSONEncodable {
  public func encode() -> JSONValue {
    return .JSONString(self)
  }
}

extension Int: JSONEncodable {
  public func encode() -> JSONValue {
    return .JSONNumber(self)
  }
}

extension Double: JSONEncodable {
  public func encode() -> JSONValue {
    return .JSONNumber(self)
  }
}

extension Bool: JSONEncodable {
  public func encode() -> JSONValue {
    return .JSONNumber(self)
  }
}

extension Float: JSONEncodable {
  public func encode() -> JSONValue {
    return .JSONNumber(self)
  }
}

//These could be JSONEncodable if Swift would allow us to provide public declarations in extension of generic types
extension Array {
  func encode() -> JSONValue {
    return .JSONArray(self.map({ ($0 as? JSONEncodable)?.encode() ?? .JSONNull }))
  }
}

extension Dictionary {
  func encode() -> JSONValue {
    var dict:JSONDict = [:]
    let casted = map(self) {($0 as? String, $1 as? JSONEncodable)}
    for (key,value) in casted {
      if let k = key {
        dict[k] = value?.encode() ?? .JSONNull
      }
    }
    return .JSONObject(dict)
  }
}
