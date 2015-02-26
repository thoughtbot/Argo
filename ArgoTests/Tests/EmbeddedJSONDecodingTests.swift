import XCTest
import Argo
import Runes

class EmbeddedJSONDecodingTests: XCTestCase {
  func testCommentDecodingWithEmbeddedUserName() {
    let comment: Comment? = JSONFileReader.JSON(fromFile: "comment") >>- decode

    XCTAssert(comment != nil)
    XCTAssert(comment?.id == 6)
    XCTAssert(comment?.text == "Cool story bro.")
    XCTAssert(comment?.authorName == "Cool User")
  }

  func testPostDecodingWithEmbeddedUserModel() {
    let post: Post? = JSONFileReader.JSON(fromFile: "post_no_comments") >>- decode

    XCTAssert(post != nil)
    XCTAssert(post?.id == 3)
    XCTAssert(post?.text == "A Cool story.")
    XCTAssert(post?.author.name == "Cool User")
    XCTAssert(post?.comments.count == 0)
  }

  func testPostDecodingWithEmbeddedUserModelAndComments() {
    let post: Post? = JSONFileReader.JSON(fromFile: "post_comments") >>- decode

    XCTAssert(post != nil)
    XCTAssert(post?.id == 3)
    XCTAssert(post?.text == "A Cool story.")
    XCTAssert(post?.author.name == "Cool User")
    XCTAssert(post?.comments.count == 2)
  }

  func testPostDecodingWithBadComments() {
    let post: Post? = JSONFileReader.JSON(fromFile: "post_bad_comments") >>- decode

    XCTAssert(post == nil)
  }
}
