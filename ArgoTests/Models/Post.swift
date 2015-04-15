import Argo
import Runes

struct Post {
  let id: Int
  let text: String
  let author: User
  let comments: [Comment]
}

extension Post: Decodable {
  static func create(id: Int)(text: String)(author: User)(comments: [Comment]) -> Post {
    return Post(id: id, text: text, author: author, comments: comments)
  }

  static func decode(j: JSON) -> Decoded<Post> {
    return Post.create
      <^> j <| "id"
      <*> j <| "text"
      <*> j <| "author"
      <*> j <|| "comments"
  }
}
