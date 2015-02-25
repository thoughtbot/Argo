import Foundation
import Runes

public struct JSONDeserializer {
  public static func deserialize(data: NSData) -> JSON? {
    let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)
    return JSON.parse <^> json
  }
}
