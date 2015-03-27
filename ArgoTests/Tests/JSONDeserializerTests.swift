import XCTest
import Argo
import Runes

class JSONDeserializerTests: XCTestCase {
  func testFailableInitializerSuccess() {
    let json = JSONFileReader.data(fromFile: "root_object") >>- { JSONDeserializer.deserialize($0) }
    let user: User? = json >>- { $0["user"] >>- User.decode }

    XCTAssert(user?.name == "Cool User")
  }

  func testFailableInitializerFailure() {
    let json = JSONDeserializer.deserialize(NSData())

    XCTAssert(json == .None)
  }
}
