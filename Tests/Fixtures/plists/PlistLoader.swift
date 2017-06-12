import Foundation

public func plist(fromFile file: String) -> Any? {
  let p = path(forFile: "\(file).plist")!

  if let dict = NSDictionary(contentsOfFile: p) { return dict }
  if let arr = NSArray(contentsOfFile: p) { return arr }

  return .none
}
