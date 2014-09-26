import Foundation

class JSONFileReader {
  class func JSON(fromFile file: String) -> AnyObject? {
    let path = NSBundle(forClass: self).pathForResource(file, ofType: "json")

    if path != nil {
      let data = NSData(contentsOfFile: path!)
      return NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)
    }

    return .None
  }
}
