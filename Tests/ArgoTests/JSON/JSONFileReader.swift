import Foundation

func path(forFile file: String, relativeTo relative: String = #file) -> String? {
  return URL(string: relative)
    .flatMap { URL(string: "\(file)", relativeTo: $0) }
    .flatMap { $0.absoluteString }
}

func json(fromFile file: String) -> Any? {
  return path(forFile: "\(file).json")
    .flatMap { FileManager.default.contents(atPath: $0) }
    .flatMap(JSONObjectWithData)
}

private func JSONObjectWithData(fromData data: Data) -> Any? {
  return try? JSONSerialization.jsonObject(with: data, options: [])
}
