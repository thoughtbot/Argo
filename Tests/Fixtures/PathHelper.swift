import Foundation

func path(forFile file: String, relativeTo relative: String = #file) -> String? {
  return URL(string: relative)
    .flatMap { URL(string: "\(file)", relativeTo: $0) }
    .flatMap { $0.absoluteString }
}
