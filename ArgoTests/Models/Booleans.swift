import Argo
import Curry

struct Booleans: Decodable {
  let bool: Bool
  let number: Bool

  static func decode(j: JSON) -> Decoded<Booleans> {
    return curry(Booleans.init)
      <^> j <| "realBool"
      <*> j <| "numberBool"
  }
}
