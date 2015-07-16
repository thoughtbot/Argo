import XCTest
import Argo

class EquatableTests: XCTestCase {
  func testEqualJSONObjects() {
    let json = JSONFromFile("types").map(JSON.parse)
    let anotherParsed = JSONFromFile("types").map(JSON.parse)

    XCTAssertEqual(json!, anotherParsed!)
  }

  func testNotEqualJSONObjects() {
    let json = JSONFromFile("types").map(JSON.parse)
    let anotherJSON = JSONFromFile("types_fail_embedded").map(JSON.parse)

    XCTAssertNotEqual(json!, anotherJSON!)
  }
}
