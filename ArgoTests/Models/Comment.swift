import Argo
import Curry
import Runes

struct Comment {
  let id: Int
  let text: String
  let authorName: String
}

extension Comment: Decodable {
  static func decode(_ json: JSON) -> Decoded<Comment> {
    return curry(self.init)
      <^> json <| "id"
      <*> json <| "text"
      <*> json <| ["author", "name"]
  }
}
