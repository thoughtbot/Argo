import XCTest
import Argo

class EmbeddedJSONDecodingTests: XCTestCase {
  func testCommentDecodingWithEmbeddedUserName() {
    do {
      let comment: Comment = try decode(JSONFromFile("comment")!)

      XCTAssert(comment.id == 6)
      XCTAssert(comment.text == "Cool story bro.")
      XCTAssert(comment.authorName == "Cool User")
    } catch {
      XCTFail()
    }
  }

  func testPostDecodingWithEmbeddedUserModel() {
    do {
      let post: Post = try decode(JSONFromFile("post_no_comments")!)

      XCTAssert(post.id == 3)
      XCTAssert(post.text == "A Cool story.")
      XCTAssert(post.author.name == "Cool User")
      XCTAssert(post.comments.count == 0)
    } catch {
      XCTFail()
    }
  }

  func testPostDecodingWithEmbeddedUserModelAndComments() {
    do {
      let post: Post = try decode(JSONFromFile("post_comments")!)

      XCTAssert(post.id == 3)
      XCTAssert(post.text == "A Cool story.")
      XCTAssert(post.author.name == "Cool User")
      XCTAssert(post.comments.count == 2)
    } catch {
      XCTFail()
    }
  }

  func testPostDecodingWithBadComments() {
    do {
      try decode(JSONFromFile("post_bad_comments")!) as Post
    } catch {
      XCTAssert(true)
    }
  }
}
