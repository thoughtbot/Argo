struct TestModel {
  let int: Int
  let string: String
  let double: Double
  let bool: Bool
//  let intOpt: Int?
  let stringArray: [String]
//  let stringArrayOpt: [String]?
//  let userOpt: User?
}

import Argo

extension TestModel: JSONDecodable {
//  static func create(int: Int)(string: String)(double: Double)(bool: Bool)(intOpt: Int?)(stringArray: [String])(stringArrayOpt: [String]?)(userOpt: User?) -> TestModel {
//    return TestModel(int: int, string: string, double: double, bool: bool, intOpt: intOpt, stringArray: stringArray, stringArrayOpt: stringArrayOpt, userOpt: userOpt)
//  }
  static func create(int: Int)(string: String)(double: Double)(bool: Bool)(stringArray: [String]) -> TestModel {
    return TestModel(int: int, string: string, double: double, bool: bool, stringArray: stringArray)
  }

  static func decode(json: JSONValue) -> TestModel? {
    println(json)
    return TestModel.create
      <^> json <| "int"
      <*> json <| "string"
      <*> json <| "double"
      <*> json <| "bool"
//      <*> json <|* "int_opt"
      <*> json <| "string_array"
//      <*> json <|* "string_array_opt"
//      <*> json <|* "user_opt"
  }
}
