import XCTest
import Argo

class EmbeddedJSONDecodingTests: XCTestCase {
  func testCommentDecodingWithEmbeddedUserName() {
    let comment: Comment? = JSONFromFile("comment").flatMap(decode)

    XCTAssert(comment != nil)
    XCTAssert(comment?.id == 6)
    XCTAssert(comment?.text == "Cool story bro.")
    XCTAssert(comment?.authorName == "Cool User")
  }

  func testPostDecodingWithEmbeddedUserModel() {
    let post: Post? = JSONFromFile("post_no_comments").flatMap(decode)

    XCTAssert(post != nil)
    XCTAssert(post?.id == 3)
    XCTAssert(post?.text == "A Cool story.")
    XCTAssert(post?.author.name == "Cool User")
    XCTAssert(post?.comments.count == 0)
  }

  func testPostDecodingWithEmbeddedUserModelAndComments() {
    let post: Post? = JSONFromFile("post_comments").flatMap(decode)

    XCTAssert(post != nil)
    XCTAssert(post?.id == 3)
    XCTAssert(post?.text == "A Cool story.")
    XCTAssert(post?.author.name == "Cool User")
    XCTAssert(post?.comments.count == 2)
  }

  func testPostDecodingWithBadComments() {
    let post: Post? = JSONFromFile("post_bad_comments").flatMap(decode)

    XCTAssert(post == nil)
  }
}
