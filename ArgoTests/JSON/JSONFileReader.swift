import Foundation
import Runes

class JSONFileReader {
  class func JSON(fromFile file: String) -> AnyObject? {
    return data(fromFile: file) >>- { NSJSONSerialization.JSONObjectWithData($0, options: NSJSONReadingOptions(0), error: nil) }

  }

  class func data(fromFile file: String) -> NSData? {
    let path = NSBundle(forClass: self).pathForResource(file, ofType: "json")
    return path >>- { NSData(contentsOfFile: $0) }
  }
}
