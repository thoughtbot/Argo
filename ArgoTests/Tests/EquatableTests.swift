import XCTest
import Argo

class EquatableTests: XCTestCase {
  func testEqualJSONObjects() {
    let json = JSON.parse(JSONFromFile("types")!)
    let anotherParsed = JSON.parse(JSONFromFile("types")!)

    XCTAssertEqual(json, anotherParsed)
  }

  func testNotEqualJSONObjects() {
    let json = JSON.parse(JSONFromFile("types")!)
    let anotherJSON = JSON.parse(JSONFromFile("types_fail_embedded")!)

    XCTAssertNotEqual(json, anotherJSON)
  }
}
