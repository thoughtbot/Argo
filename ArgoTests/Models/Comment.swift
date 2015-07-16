import Argo
import Curry

struct Comment {
  let id: Int
  let text: String
  let authorName: String
}

extension Comment: Decodable {
  static func decode(j: JSON) -> Decoded<Comment> {
    return curry(self.init)
      <^> j <| "id"
      <*> j <| "text"
      <*> j <| ["author", "name"]
  }
}
