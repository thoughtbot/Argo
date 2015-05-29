import Foundation
import Runes

func JSONFromFile(file: String) -> AnyObject? {
  return NSBundle(forClass: JSONFileReader.self).pathForResource(file, ofType: "json")
    >>- { NSData(contentsOfFile: $0) }
    >>- { NSJSONSerialization.JSONObjectWithData($0, options: NSJSONReadingOptions(0), error: nil) }
}

private class JSONFileReader { }
