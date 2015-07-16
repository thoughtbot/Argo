import Argo
import Runes
import Curry

struct Post {
  let id: Int
  let text: String
  let author: User
  let comments: [Comment]
}

extension Post: Decodable {
  static func decode(j: JSON) -> Decoded<Post> {
    return curry(Post.init)
      <^> j <| "id"
      <*> j <| "text"
      <*> j <| "author"
      <*> j <|| "comments"
  }
}
