import Foundation

class PListFileReader {
  class func plist(fromFile file: String) -> AnyObject? {
    let path = Bundle(for: self).pathForResource(file, ofType: "plist")

    if let p = path {
      if let dict = NSDictionary(contentsOfFile: p) { return dict }
      if let arr = NSArray(contentsOfFile: p) { return arr }
    }

    return .none
  }
}
