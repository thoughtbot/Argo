struct TestModel {
  let int: Int
  let string: String
  let double: Double
  let bool: Bool
  let intOpt: Int?
  let stringArray: [String]
  let stringArrayOpt: [String]?
  let eStringArray: [String]
  let eStringArrayOpt: [String]?
  let userOpt: User?
}

import Argo

extension TestModel: JSONDecodable {
  static func create(int: Int)(string: String)(double: Double)(bool: Bool)(intOpt: Int?)(stringArray: [String])(stringArrayOpt: [String]?)(eStringArray: [String])(eStringArrayOpt: [String]?)(userOpt: User?) -> TestModel {
    return TestModel(int: int, string: string, double: double, bool: bool, intOpt: intOpt, stringArray: stringArray, stringArrayOpt: stringArrayOpt, eStringArray: eStringArray, eStringArrayOpt: eStringArrayOpt, userOpt: userOpt)
  }

  static var decoder: JSONValue -> TestModel? {
    return TestModel.create
      <^> <|"int"
      <*> <|["user_opt", "name"]
      <*> <|"double"
      <*> <|"bool"
      <*> <|*"int_opt"
      <*> <||"string_array"
      <*> <||*"string_array_opt"
      <*> <||["embedded", "string_array"]
      <*> <||*["embedded", "string_array_opt"]
      <*> <|*"user_opt"
  }
}
