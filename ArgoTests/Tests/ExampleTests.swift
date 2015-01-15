import XCTest
import Argo
import Runes

class ExampleTests: XCTestCase {
  func testJSONWithRootArray() {
    let json = JSONValue.parse <^> JSONFileReader.JSON(fromFile: "array_root")
    let stringArray: [String]? = json >>- JSONValue.mapDecode

    XCTAssertNotNil(stringArray)
    XCTAssertEqual(stringArray!, ["foo", "bar", "baz"])
  }

  func testJSONWithRootObject() {
    let json = JSONValue.parse <^> JSONFileReader.JSON(fromFile: "root_object")
    let user: User? = json >>- { $0["user"] >>- User.decode }

    XCTAssert(user != nil)
    XCTAssert(user?.id == 1)
    XCTAssert(user?.name == "Cool User")
    XCTAssert(user?.email != nil)
    XCTAssert(user?.email! == "u.cool@example.com")
  }

  func testDecodingNonFinalClass() {
    let json = JSONValue.parse <^> JSONFileReader.JSON(fromFile: "url")
    let url: NSURL? = json >>- { $0["url"] >>- NSURL.decode }

    XCTAssert(url != nil)
    XCTAssert(url?.absoluteString == "http://example.com")
  }

  func testDecodingJSONWithRootArray() {
    let expected = JSONValue.parse([["title": "Foo", "age": 21], ["title": "Bar", "age": 32]])
    let json = JSONValue.parse <^> JSONFileReader.JSON(fromFile: "root_array")

    XCTAssert(.Some(expected) == json)
  }
}
