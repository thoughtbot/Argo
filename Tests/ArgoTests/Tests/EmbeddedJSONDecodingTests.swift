import XCTest
import Argo

class EmbeddedJSONDecodingTests: XCTestCase {
  func testCommentDecodingWithEmbeddedUserName() {
    let comment: Comment? = json(fromFile: "comment").flatMap(decode)

    XCTAssertEqual(comment?.id, 6)
    XCTAssertEqual(comment?.text, "Cool story bro.")
    XCTAssertEqual(comment?.authorName, "Cool User")
  }

  func testPostDecodingWithEmbeddedUserModel() {
    let post: Post? = json(fromFile: "post_no_comments").flatMap(decode)

    XCTAssertEqual(post?.id, 3)
    XCTAssertEqual(post?.text, "A Cool story.")
    XCTAssertEqual(post?.author.name, "Cool User")
    XCTAssertEqual(post?.comments.count, 0)
  }

  func testPostDecodingWithEmbeddedUserModelAndComments() {
    let post: Post? = json(fromFile: "post_comments").flatMap(decode)

    XCTAssertEqual(post?.id, 3)
    XCTAssertEqual(post?.text, "A Cool story.")
    XCTAssertEqual(post?.author.name, "Cool User")
    XCTAssertEqual(post?.comments.count, 2)
  }

  func testPostDecodingWithBadComments() {
    let post: Post? = json(fromFile: "post_bad_comments").flatMap(decode)

    XCTAssertNil(post)
  }
}
