import XCTest
import Argo
import Runes

class TypeTests: XCTestCase {
  func testAllTheTypes() {
    let json = JSONValue.parse <^> JSONFileReader.JSON(fromFile: "types")
    let model = json >>- TestModel.decode

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

  func testFailingEmbedded() {
    let json = JSONValue.parse <^> JSONFileReader.JSON(fromFile: "types_fail_embedded")
    let model = json >>- TestModel.decode

    XCTAssert(model == nil)
  }
}
