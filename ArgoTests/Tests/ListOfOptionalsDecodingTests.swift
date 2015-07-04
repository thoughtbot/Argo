import XCTest
import Argo
import Runes

class ListOfOptionalsDecodingTests: XCTestCase {
  func testPostDecodingWithBadComments() {
    let post: ResilientPost? = JSONFromFile("post_bad_comments") >>- decode

    XCTAssert(post != nil)
    XCTAssert(post?.id == 3)
    XCTAssert(post?.text == "A Cool story.")
    XCTAssert(post?.author.name == "Cool User")
    XCTAssert(post?.comments.count == 1)
  }
}
