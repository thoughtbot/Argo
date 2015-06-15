import XCTest
import Argo

class OptionalPropertyDecodingTests: XCTestCase {
  func testUserDecodingWithEmail() {
    do {
      let user: User = try decode(JSONFromFile("user_with_email")!)

      XCTAssert(user.id == 1)
      XCTAssert(user.name == "Cool User")
      XCTAssert(user.email != nil)
      XCTAssert(user.email! == "u.cool@example.com")
    } catch {
      XCTFail()
    }
  }

  func testUserDecodingWithoutEmail() {
    do {
      let user: User = try decode(JSONFromFile("user_without_email")!)

      XCTAssert(user.id == 1)
      XCTAssert(user.name == "Cool User")
      XCTAssert(user.email == nil)
    } catch {
      XCTFail()
    }
  }
}
