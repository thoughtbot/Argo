import Argo
import Runes
import Curry

struct PartialTestModel {
  let string: String
  let bool: Bool
  let stringArray: [String]
}

extension PartialTestModel: Decodable {
  static func decode(_ json: JSON) -> Decoded<PartialTestModel> {
    let curriedInit = curry(self.init)
    return curriedInit
      <^> json <| ["user_opt", "name"]
      <*> json <| "bool"
      <*> json <|| "string_array"
  }
}
