struct TestModel {
  let int: Int
  let string: String
  let double: Double
  let bool: Bool
  let intOpt: Int?
  let stringArray: [String]
  let stringArrayOpt: [String]?
  let userOpt: User?
}

import Argo

extension TestModel: JSONDecodable {
  static func create(int: Int)(string: String)(double: Double)(bool: Bool)(intOpt: Int?)(stringArray: [String])(stringArrayOpt: [String]?)(userOpt: User?) -> TestModel {
    return TestModel(int: int, string: string, double: double, bool: bool, intOpt: intOpt, stringArray: stringArray, stringArrayOpt: stringArrayOpt, userOpt: userOpt)
  }

  static func decode(json: JSON) -> TestModel? {
    return _JSONParse(json) >>- { d in
      TestModel.create
        <^> d <| "int"
        <*> d <| "string"
        <*> d <| "double"
        <*> d <| "bool"
        <*> d <|* "int_opt"
        <*> d <| "string_array"
        <*> d <|* "string_array_opt"
        <*> d <|* "user_opt"
    }
  }
}
