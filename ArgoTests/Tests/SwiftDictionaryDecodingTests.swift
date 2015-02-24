import XCTest
import Argo

class SwiftDictionaryDecodingTests: XCTestCase {
  func testDecodingAllTypesFromSwiftDictionary() {
    let typesDict = [
      "int": 5,
      "double": 3.4,
      "float": 1.1,
      "bool": false,
      "int_opt": 4,
      "string_array": ["hello", "world"],
      "embedded": [
        "string_array": ["hello", "world"],
        "string_array_opt": []
      ],
      "user_opt": [
        "id": 6,
        "name": "Cooler User"
      ]
    ]

    let value = JSON.parse(typesDict)
    let model = TestModel.decode(value)

    XCTAssert(model != nil)
    XCTAssert(model?.int == 5)
    XCTAssert(model?.string == "Cooler User")
    XCTAssert(model?.double == 3.4)
    XCTAssert(model?.float == 1.1)
    XCTAssert(model?.bool == false)
    XCTAssert(model?.intOpt != nil)
    XCTAssert(model?.intOpt! == 4)
    XCTAssert(model?.stringArray.count == 2)
    XCTAssert(model?.stringArrayOpt == nil)
    XCTAssert(model?.eStringArray.count == 2)
    XCTAssert(model?.eStringArrayOpt != nil)
    XCTAssert(model?.eStringArrayOpt?.count == 0)
    XCTAssert(model?.userOpt != nil)
    XCTAssert(model?.userOpt?.id == 6)
  }
}
