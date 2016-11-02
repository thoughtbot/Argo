import XCTest
import Argo

enum TestRawString: String {
  case CoolString
  case NotCoolStringBro
}

enum TestRawInt: Int {
  case zero
  case one
}

extension TestRawString: Decodable { }
extension TestRawInt: Decodable { }

class RawRepresentable: XCTestCase {
  func testStringEnum() {
    let json = JSON.object([
      "string": JSON.string("CoolString"),
      "another": JSON.string("NotCoolStringBro")
      ])

    let string: TestRawString? = (json <| "string").value
    let another: TestRawString? = (json <| "another").value
    XCTAssert(TestRawString.CoolString == string)
    XCTAssert(TestRawString.NotCoolStringBro == another)
  }

  func testIntEnum() {
    let json = JSON.object([
      "zero": JSON.number(0),
      "one": JSON.number(1)
      ])

    let zero: TestRawInt? = (json <| "zero").value
    let one: TestRawInt? = (json <| "one").value
    XCTAssert(TestRawInt.zero == zero)
    XCTAssert(TestRawInt.one == one)
  }
}
