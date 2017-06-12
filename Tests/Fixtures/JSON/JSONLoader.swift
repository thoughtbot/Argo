import Foundation

public func json(fromFile file: String) -> Any? {
  return path(forFile: "\(file).json")
    .flatMap { FileManager.default.contents(atPath: $0) }
    .flatMap(JSONObjectWithData)
}

private func JSONObjectWithData(fromData data: Data) -> Any? {
  return try? JSONSerialization.jsonObject(with: data, options: [])
}
