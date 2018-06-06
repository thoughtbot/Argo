import Argo
import Curry
import Runes

struct TestModel {
  let numerics: TestModelNumerics
  let string: String
  let bool: Bool
  let stringArray: [String]
  let stringArrayOpt: [String]?
  let eStringArray: [String]
  let eStringArrayOpt: [String]?
  let userOpt: User?
  let dict: [String: String]
}

extension TestModel: Argo.Decodable {
  static func decode(_ value: Value) -> Decoded<TestModel> {
    let curriedInit = curry(self.init)
    return curriedInit
      <^> value["numerics"]
      <*> value["user_opt", "name"]
      <*> value["bool"]
      <*> value["string_array"]
      <*> value[optional: "string_array_opt"]
      <*> value["embedded", "string_array"]
      <*> value[optional: "embedded", "string_array_opt"]
      <*> value[optional: "user_opt"]
      <*> value["dict"]
  }
}

struct TestModelNumerics {
  let int: Int
  let int64: Int64
  let int64String: Int64
  let double: Double
  let float: Float
  let intOpt: Int?
  let uint: UInt
  let uint64: UInt64
  let uint64String: UInt64
}

extension TestModelNumerics: Argo.Decodable {
  static func decode(_ value: Value) -> Decoded<TestModelNumerics> {
    let f = curry(self.init)
      <^> value["int"]
      <*> value["int64"]
      <*> value["int64_string"]
      <*> value["double"]
      <*> value["float"]
      <*> value[optional: "int_opt"]

    return f
      <*> value["uint"]
      <*> value["uint64"]
      <*> value["uint64_string"]
  }
}
