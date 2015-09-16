import Foundation

func JSONFromFile(file: String) -> AnyObject? {
  return NSBundle(forClass: JSONFileReader.self).pathForResource(file, ofType: "json")
    .flatMap { NSData(contentsOfFile: $0) }
    .flatMap(JSONObjectWithData)
}

private func JSONObjectWithData(data: NSData) -> AnyObject? {
  return try? NSJSONSerialization.JSONObjectWithData(data, options: [])
}

private class JSONFileReader { }
