import XCTest
import Argo
import Runes

class EquatableSpec: XCTestCase {
  func testEqualJSONObjects() {
    let json: AnyObject? = JSONFileReader.JSON(fromFile: "types")
    let parsed = json >>- JSONValue.parse
    let anotherParsed = json >>- JSONValue.parse

    XCTAssertEqual(parsed!, anotherParsed!)
  }

  func testNotEqualJSONObjects() {
    let json: AnyObject? = JSONFileReader.JSON(fromFile: "types")
    let anotherJSON: AnyObject? = JSONFileReader.JSON(fromFile: "types_fail_embedded")
    let parsed = json >>- JSONValue.parse
    let anotherParsed = anotherJSON >>- JSONValue.parse

    XCTAssertNotEqual(parsed!, anotherParsed!)
  }
}
