import XCTest
import Argo
import Runes

class EquatableSpec: XCTestCase {
  func testEqualJSONObjects() {
    let json = JSONValue.parse <^> JSONFileReader.JSON(fromFile: "types")
    let anotherParsed = JSONValue.parse <^> JSONFileReader.JSON(fromFile: "types")

    XCTAssertEqual(json!, anotherParsed!)
  }

  func testNotEqualJSONObjects() {
    let json = JSONValue.parse <^> JSONFileReader.JSON(fromFile: "types")
    let anotherJSON = JSONValue.parse <^> JSONFileReader.JSON(fromFile: "types_fail_embedded")

    XCTAssertNotEqual(json!, anotherJSON!)
  }
}
