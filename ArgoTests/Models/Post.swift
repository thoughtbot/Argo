import Argo
import Curry
import Runes

struct Post {
  let id: Int
  let text: String
  let author: User
  let comments: [Comment]
}

extension Post: Decodable {
  static func decode(_ json: JSON) -> Decoded<Post> {
    return curry(self.init)
      <^> json <| "id"
      <*> json <| "text"
      <*> json <| "author"
      <*> json <|| "comments"
  }
}
