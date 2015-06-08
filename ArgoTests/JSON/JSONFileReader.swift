import Foundation
import Runes

func JSONFromFile(file: String) -> AnyObject? {
  return NSBundle(forClass: JSONFileReader.self).pathForResource(file, ofType: "json")
    >>- { NSData(contentsOfFile: $0) }
    >>- JSONObjectWithData
}

private func JSONObjectWithData(data: NSData) -> AnyObject? {
  do { return try NSJSONSerialization.JSONObjectWithData(data, options: []) }
  catch _ { return .None }
}

private class JSONFileReader { }
