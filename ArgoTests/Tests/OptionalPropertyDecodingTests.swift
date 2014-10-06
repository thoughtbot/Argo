import XCTest
import Argo

class OptionalPropertyDecodingTests: XCTestCase {
  func testUserDecodingWithEmail() {
    let json: AnyObject? = JSONFileReader.JSON(fromFile: "user_with_email")
    let user = json >>- JSONValue.parse >>- User.decoder

    XCTAssert(user != nil)
    XCTAssert(user?.id == 1)
    XCTAssert(user?.name == "Cool User")
    XCTAssert(user?.email != nil)
    XCTAssert(user?.email! == "u.cool@example.com")
  }

  func testUserDecodingWithoutEmail() {
    let json: AnyObject? = JSONFileReader.JSON(fromFile: "user_without_email")
    let user = json >>- JSONValue.parse >>- User.decoder

    XCTAssert(user != nil)
    XCTAssert(user?.id == 1)
    XCTAssert(user?.name == "Cool User")
    XCTAssert(user?.email == nil)
  }
}
