import Foundation

func json(fromFile file: String) -> AnyObject? {
  return Bundle(for: JSONFileReader.self).pathForResource(file, ofType: "json")
    .flatMap { URL(fileURLWithPath: $0) }
    .flatMap { try? Data(contentsOf: $0) }
    .flatMap(JSONObjectWithData)
}

private func JSONObjectWithData(fromData data: Data) -> AnyObject? {
  return try? JSONSerialization.jsonObject(with: data, options: [])
}

private class JSONFileReader { }
