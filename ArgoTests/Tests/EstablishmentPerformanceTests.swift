//
//  EstablishmentPerformanceTests.swift
//  Argo
//
//  Created by David on 05/11/2015.
//  Copyright © 2015 thoughtbot. All rights reserved.
//

import XCTest
import Argo

class EstablishmentPerformanceTests: XCTestCase {
    
    func testEstablishmentDecodePerformance() {
      var establishments: [Establishment]?
      let json = JSONFromFile("establishments")
        self.measureBlock {
          establishments = json.flatMap(decode)
        }

        XCTAssertNotNil(establishments)
    }
    
}
