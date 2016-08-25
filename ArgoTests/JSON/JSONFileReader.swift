import Foundation

func json(fromFile file: String) -> Any? {
  return Bundle(for: JSONFileReader.self).path(forResource: file, ofType: "json")
    .flatMap { URL(fileURLWithPath: $0) }
    .flatMap { try? Data(contentsOf: $0) }
    .flatMap(JSONObjectWithData)
}

private func JSONObjectWithData(fromData data: Data) -> Any? {
  return try? JSONSerialization.jsonObject(with: data, options: [])
}

private class JSONFileReader { }
