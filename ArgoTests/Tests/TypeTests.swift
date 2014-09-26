import XCTest
import Argo

class TypeTests: XCTestCase {
  func testAllTheTypes() {
    let json: JSON? = JSONFileReader.JSON(fromFile: "types")
    let model = json >>- JSONValue.parse >>- TestModel.decode

    XCTAssert(model != nil)
    XCTAssert(model?.int == 5)
    XCTAssert(model?.string == "Cool string")
    XCTAssert(model?.double == 3.4)
    XCTAssert(model?.bool == false)
    XCTAssert(model?.intOpt != nil)
//    XCTAssert(model?.stringArray.count == 2)
  }
}

