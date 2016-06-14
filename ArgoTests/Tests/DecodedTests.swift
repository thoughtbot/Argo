import XCTest
import Argo

class DecodedTests: XCTestCase {
  func testDecodedSuccess() {
    let user: Decoded<User> = decode(JSONFromFile(file: "user_with_email")!)

    switch user {
    case let .Success(x): XCTAssert(user.description == "Success(\(x))")
    default: XCTFail("Unexpected Case Occurred")
    }
  }
  
  func testDecodedWithError() {
    let user: Decoded<User> = decode(JSONFromFile(file: "user_with_bad_type")!)
    
    switch user.error {
    case .some: XCTAssert(true)
    case .none: XCTFail("Unexpected Success")
    }
  }
  
  func testDecodedWithNoError() {
    let user: Decoded<User> = decode(JSONFromFile(file: "user_with_email")!)
    
    switch user.error {
    case .some: XCTFail("Unexpected Error Occurred")
    case .none: XCTAssert(true)
    }
  }

  func testDecodedTypeMissmatch() {
    let user: Decoded<User> = decode(JSONFromFile(file: "user_with_bad_type")!)

    switch user {
    case let .Failure(.TypeMismatch(expected, actual)): XCTAssert(user.description == "Failure(TypeMismatch(Expected \(expected), got \(actual)))")
    default: XCTFail("Unexpected Case Occurred")
    }
  }

  func testDecodedMissingKey() {
    let user: Decoded<User> = decode(JSONFromFile(file: "user_without_key")!)

    switch user {
    case let .Failure(.MissingKey(s)): XCTAssert(user.description == "Failure(MissingKey(\(s)))")
    default: XCTFail("Unexpected Case Occurred")
    }
  }

  func testDecodedCustomError() {
    let customError: Decoded<Dummy> = decode([:])

    switch customError {
    case let .Failure(e): XCTAssert(e.description == "Custom(My Custom Error)")
    default: XCTFail("Unexpected Case Occurred")
    }
  }
  
  func testDecodedMaterializeSuccess() {
    let user: Decoded<User> = decode(JSONFromFile(file: "user_with_email")!)
    let materialized = materialize { user.value! }
    
    switch materialized {
    case let .Success(x): XCTAssert(user.description == "Success(\(x))")
    default: XCTFail("Unexpected Case Occurred")
    }
  }
  
  func testDecodedMaterializeFailure() {
    let error = NSError(domain: "com.thoughtbot.Argo", code: 0, userInfo: nil)
    let materialized = materialize { throw error }
    
    switch materialized {
    case let .Failure(e): XCTAssert(e.description == "Custom(\(error.description))")
    default: XCTFail("Unexpected Case Occurred")
    }
  }
  
  func testDecodedDematerializeSuccess() {
    let user: Decoded<User> = decode(JSONFromFile(file: "user_with_email")!)
    
    do {
      _ = try user.dematerialize()
      XCTAssert(true)
    } catch {
      XCTFail("Unexpected Error Occurred")
    }
  }
  
  func testDecodedDematerializeTypeMismatch() {
    let user: Decoded<User> = decode(JSONFromFile(file: "user_with_bad_type")!)
    
    do {
      _ = try user.dematerialize()
      XCTFail("Unexpected Success")
    } catch DecodeError.TypeMismatch {
      XCTAssert(true)
    } catch DecodeError.MissingKey {
      XCTFail("Unexpected Error Occurred")
    } catch {
      XCTFail("Unexpected Error Occurred")
    }
  }
  
  func testDecodedDematerializeMissingKey() {
    let user: Decoded<User> = decode(JSONFromFile(file: "user_without_key")!)
    
    do {
      _ = try user.dematerialize()
      XCTFail("Unexpected Success")
    } catch DecodeError.MissingKey {
      XCTAssert(true)
    } catch DecodeError.TypeMismatch {
      XCTFail("Unexpected Error Occurred")
    } catch {
      XCTFail("Unexpected Error Occurred")
    }
  }

  func testDecodedOrWithSuccess() {
    let successUser: Decoded<User> = decode(JSONFromFile(file: "user_with_email")!)
    let failedUser: Decoded<User> = decode(JSONFromFile(file: "user_with_bad_type")!)

    let result = successUser.or(failedUser)

    switch result {
    case .Success: XCTAssert(result.description == successUser.description)
    default: XCTFail("Unexpected Case Occurred")
    }
  }

  func testDecodedOrWithError() {
    let successUser: Decoded<User> = decode(JSONFromFile(file: "user_with_email")!)
    let failedUser: Decoded<User> = decode(JSONFromFile(file: "user_with_bad_type")!)

    let result = failedUser.or(successUser)

    switch result {
    case .Success: XCTAssert(result.description == successUser.description)
    default: XCTFail("Unexpected Case Occurred")
    }
  }
}

private struct Dummy: Decodable {
  static func decode(_ json: JSON) -> Decoded<Dummy> {
    return .Failure(.Custom("My Custom Error"))
  }
}
