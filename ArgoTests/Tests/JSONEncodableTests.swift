//
//  JSONEncodableTests.swift
//  Argo
//
//  Created by Niels van Hoorn on 10/02/15.
//  Copyright (c) 2015 thoughtbot. All rights reserved.
//

import Foundation

import XCTest
import Argo
import Runes

class JSONEncodableTests: XCTestCase {
  func testJSONWithRootArray() {
    let json = JSONValue.parse <^> JSONFileReader.JSON(fromFile: "array_root")
    let array: JSONValue = ["foo", "bar", "baz"]
    XCTAssert(json != nil)
    XCTAssertEqual(json!, array)
  }

  func testJSONWithRootObject() {
    let json = JSONValue.parse <^> JSONFileReader.JSON(fromFile: "root_object")
    let user: User? = json >>- { $0["user"] >>- User.decode }
    let rootObject: JSONValue = ["user":user]
    XCTAssert(json != nil)
    XCTAssertEqual(json!,rootObject)
  }
  
  func testEncodingNonFinalClass() {
    let json = JSONValue.parse <^> JSONFileReader.JSON(fromFile: "url")
    let url: NSURL? = json >>- { $0["url"] >>- NSURL.decode }
    let jsonValue: JSONValue = ["url":url]
    XCTAssert(url != nil)
    XCTAssertEqual(json!,jsonValue)
  }

  func testDecodingJSONWithRootArray() {
    let json = JSONValue.parse <^> JSONFileReader.JSON(fromFile: "root_array")
    let first: JSONValue = ["title": "Foo", "age": 21]
    let second: JSONValue = ["title": "Bar", "age": 32]
    let expected: JSONValue = [first, second]
    XCTAssert(json != nil)
    XCTAssertEqual(expected,json!)
  }

  func testModelWithAllTypes() {
    let json = JSONValue.parse <^> JSONFileReader.JSON(fromFile: "types")
    let model = json >>- TestModel.decode
    
    XCTAssert(json != nil)
    XCTAssert(model != nil)
    XCTAssertEqual(json!,model!.encode())
  }

  func testCommentDecodingWithEmbeddedUserName() {
    let json = JSONValue.parse <^> JSONFileReader.JSON(fromFile: "comment")
    let comment = json >>- Comment.decode
    
    XCTAssert(json != nil)
    XCTAssert(comment != nil)
    XCTAssertEqual(comment!.encode(), json!)
  }
  
  func testPostDecodingWithEmbeddedUserModel() {
    let json = JSONValue.parse <^> JSONFileReader.JSON(fromFile: "post_no_comments")
    let post = json >>- Post.decode
    
    XCTAssert(post != nil)
    XCTAssert(post != nil)
    XCTAssertEqual(post!.encode(), json!)
  }
  
  func testPostDecodingWithEmbeddedUserModelAndComments() {
    let json = JSONValue.parse <^> JSONFileReader.JSON(fromFile: "post_comments")
    let post = json >>- Post.decode
    
    XCTAssert(post != nil)
    XCTAssert(post != nil)
    XCTAssertEqual(post!.encode(), json!)
  }

}
