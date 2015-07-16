import Foundation

func JSONFromFile(file: String) -> AnyObject? {
  return NSBundle(forClass: JSONFileReader.self).pathForResource(file, ofType: "json")
    .flatMap { NSData(contentsOfFile: $0) }
    .flatMap(JSONObjectWithData)
}

private func JSONObjectWithData(data: NSData) -> AnyObject? {
  do { return try NSJSONSerialization.JSONObjectWithData(data, options: []) }
  catch { return .None }
}

private class JSONFileReader { }
