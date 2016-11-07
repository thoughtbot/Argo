import Foundation
import CoreFoundation

extension NSNumber {
  var isBool: Bool {
    return CFBooleanGetTypeID() == CFGetTypeID(self)
  }
}
