import XCTest
import Argo
import Runes

class EquatableTests: XCTestCase {
  func testEqualJSONObjects() {
    let json = JSON.parse <^> JSONFileReader.JSON(fromFile: "types")
    let anotherParsed = JSON.parse <^> JSONFileReader.JSON(fromFile: "types")

    XCTAssertEqual(json!, anotherParsed!)
  }

  func testNotEqualJSONObjects() {
    let json = JSON.parse <^> JSONFileReader.JSON(fromFile: "types")
    let anotherJSON = JSON.parse <^> JSONFileReader.JSON(fromFile: "types_fail_embedded")

    XCTAssertNotEqual(json!, anotherJSON!)
  }
}
