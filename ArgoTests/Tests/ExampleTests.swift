import XCTest
import Argo

class ExampleTests: XCTestCase {
  func testJSONWithRootArray() {
    do {
      let stringArray: [String] = try decode(JSONFromFile("array_root")!)

      XCTAssertEqual(stringArray, ["foo", "bar", "baz"])
    } catch {
      XCTFail()
    }
  }

  func testJSONWithRootObject() {
    do {
      let json = JSON.parse(JSONFromFile("root_object")!)
      let user: User = try json <| "user"

      XCTAssert(user.id == 1)
      XCTAssert(user.name == "Cool User")
      XCTAssert(user.email != nil)
      XCTAssert(user.email! == "u.cool@example.com")
    } catch {
      XCTFail()
    }
  }

  func testDecodingNonFinalClass() {
    do {
      let json = JSON.parse(JSONFromFile("url")!)
      let url: NSURL = try json <| "url"

      XCTAssert(url.absoluteString == "http://example.com")
    } catch {
      XCTFail()
    }
  }

  func testDecodingJSONWithRootArray() {
    let expected = JSON.parse([["title": "Foo", "age": 21], ["title": "Bar", "age": 32]])
    let json = JSON.parse(JSONFromFile("root_array")!)

    XCTAssert(expected == json)
  }

  func testFlatMapOptionals() {
    do {
      let user: User = try decode(JSONFromFile("user_with_email")!)

      XCTAssert(user.id == 1)
      XCTAssert(user.name == "Cool User")
      XCTAssert(user.email == "u.cool@example.com")
    } catch {
      XCTFail()
    }
  }
}
