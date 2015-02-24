import XCTest
import Argo
import Runes

class OptionalPropertyDecodingTests: XCTestCase {
  func testUserDecodingWithEmail() {
    let json = JSON.parse <^> JSONFileReader.JSON(fromFile: "user_with_email")
    let user = json >>- User.decode

    XCTAssert(user != nil)
    XCTAssert(user?.id == 1)
    XCTAssert(user?.name == "Cool User")
    XCTAssert(user?.email != nil)
    XCTAssert(user?.email! == "u.cool@example.com")
  }

  func testUserDecodingWithoutEmail() {
    let json = JSON.parse <^> JSONFileReader.JSON(fromFile: "user_without_email")
    let user = json >>- User.decode

    XCTAssert(user != nil)
    XCTAssert(user?.id == 1)
    XCTAssert(user?.name == "Cool User")
    XCTAssert(user?.email == nil)
  }
}
