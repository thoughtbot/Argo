import Foundation
import CoreFoundation

extension NSNumber {
  var isBool: Bool {
    return type(of: self) == type(of: NSNumber(value: true))
  }
}
