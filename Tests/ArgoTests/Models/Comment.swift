import Argo
import Curry
import Runes

struct Comment {
  let id: Int
  let text: String
  let authorName: String
}

extension Comment: Argo.Decodable {
  static func decode(_ value: Value) -> Decoded<Comment> {
    return curry(self.init)
      <^> value["id"]
      <*> value["text"]
      <*> value["author", "name"]
  }
}
