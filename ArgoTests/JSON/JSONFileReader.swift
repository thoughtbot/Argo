import Foundation
import Runes

func JSONFromFile(file: String) -> AnyObject? {
  return NSBundle(forClass: JSONFileReader.self).pathForResource(file, ofType: "json")
    >>- { NSData(contentsOfFile: $0) }
    >>- parseJSON
}

private class JSONFileReader { }

func parseJSON(data: NSData) -> AnyObject? {
  do {
    return try NSJSONSerialization.JSONObjectWithData(data, options: [])
  }
  catch _ {
    return .None
  }
}
