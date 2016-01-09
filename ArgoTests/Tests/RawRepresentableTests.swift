import XCTest
import Argo

enum TestRawString: String {
  case CoolString
  case NotCoolStringBro
}

enum TestRawInt: Int {
  case Zero
  case One
}

extension TestRawString: Decodable { }
extension TestRawInt: Decodable { }

class RawRepresentable: XCTestCase {
  func testStringEnum() {
    let json = JSON.Object([
      "string": LazyJSON("CoolString"),
      "another": LazyJSON("NotCoolStringBro")
      ])

    let string: TestRawString? = json <| "string"
    let another: TestRawString? = json <| "another"
    XCTAssert(TestRawString.CoolString == string)
    XCTAssert(TestRawString.NotCoolStringBro == another)
  }

  func testIntEnum() {
    let json = JSON.Object([
      "zero": LazyJSON(0),
      "one": LazyJSON(1)
      ])

    let zero: TestRawInt? = json <| "zero"
    let one: TestRawInt? = json <| "one"
    XCTAssert(TestRawInt.Zero == zero)
    XCTAssert(TestRawInt.One == one)
  }
}
