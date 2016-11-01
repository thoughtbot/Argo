import Foundation

extension NSNumber {
  var isBool: Bool {
    return CFBooleanGetTypeID() == CFGetTypeID(self)
  }
}
