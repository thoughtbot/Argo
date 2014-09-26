import XCTest
import Argo

class EmbeddedJSONDecodingTests: XCTestCase {
  func testCommentDecodingWithEmbeddedUserName() {
    let json: JSON? = JSONFileReader.JSON(fromFile: "comment")
    let comment = json >>- Comment.decode

    XCTAssert(comment != nil)
    XCTAssert(comment?.id == 6)
    XCTAssert(comment?.text == "Cool story bro.")
    XCTAssert(comment?.authorName == "Cool User")
  }

  func testPostDecodingWithEmbeddedUserModel() {
    let json: JSON? = JSONFileReader.JSON(fromFile: "post_no_comments")
    let post = json >>- Post.decode

    XCTAssert(post != nil)
    XCTAssert(post?.id == 3)
    XCTAssert(post?.text == "A Cool story.")
    XCTAssert(post?.author.name == "Cool User")
    XCTAssert(post?.comments.count == 0)
  }
}
