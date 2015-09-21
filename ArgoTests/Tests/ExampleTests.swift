import XCTest
import Argo
import Curry

class ExampleTests: XCTestCase {
  func testJSONWithRootArray() {
    let stringArray: [String]? = JSONFromFile("array_root").flatMap(decode)

    XCTAssertNotNil(stringArray)
    XCTAssertEqual(stringArray!, ["foo", "bar", "baz"])
  }

  func testJSONWithRootObject() {
    let user: User? = JSONFromFile("root_object").flatMap(curry(decodeWithRootKey)("user"))

    XCTAssert(user != nil)
    XCTAssert(user?.id == 1)
    XCTAssert(user?.name == "Cool User")
    XCTAssert(user?.email != nil)
    XCTAssert(user?.email! == "u.cool@example.com")
  }

  func testDecodingNonFinalClass() {
    let url: NSURL? = JSONFromFile("url").flatMap(curry(decodeWithRootKey)("url"))

    XCTAssert(url != nil)
    XCTAssert(url?.absoluteString == "http://example.com")
  }

  func testDecodingJSONWithRootArray() {
    let expected = JSON.parse([["title": "Foo", "age": 21], ["title": "Bar", "age": 32]])
    let json = JSONFromFile("root_array").map(JSON.parse)

    XCTAssert(.Some(expected) == json)
  }

  func testFlatMapOptionals() {
    let json: AnyObject? = JSONFromFile("user_with_email")
    let user: User? = json.flatMap(decode)

    XCTAssert(user?.id == 1)
    XCTAssert(user?.name == "Cool User")
    XCTAssert(user?.email == "u.cool@example.com")
  }
  
  func testNilCoalescing() {
    let json: AnyObject? = JSONFromFile("user_with_nested_name")
    let user: User? = json.flatMap(decode)

    XCTAssert(user?.id == 1)
    XCTAssert(user?.name == "Very Cool User")
    XCTAssert(user?.email == "u.cool@example.com")
  }

  func testFlatMapDecoded() {
    let json: AnyObject? = JSONFromFile("user_with_email")
    let user: Decoded<User> = .fromOptional(json) >>- decode

    XCTAssert(user.value?.id == 1)
    XCTAssert(user.value?.name == "Cool User")
    XCTAssert(user.value?.email == "u.cool@example.com")
  }
}
