import Argo
import Curry
import Runes

struct Booleans: Argo.Decodable {
  let bool: Bool
  let number: Bool

  static func decode(_ value: Value) -> Decoded<Booleans> {
    return curry(Booleans.init)
      <^> value["realBool"]
      <*> value["numberBool"]
  }
}
