import XCTest
import Argo
import Runes

class JSONTests: XCTestCase {
  func testFailableInitializerSuccess() {
    let json = JSONFileReader.data(fromFile: "root_object") >>- { JSON(data: $0) }
    let user: User? = json >>- { $0["user"] >>- User.decode }

    XCTAssert(user?.name == "Cool User")
  }

  func testFailableInitializerFailure() {
    let json = JSON(data: NSData())

    XCTAssert(json == .None)
  }
}
