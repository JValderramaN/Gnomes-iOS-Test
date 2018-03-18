//
//  GnomesTests.swift
//  GnomesTests
//
//  Created by José Valderrama on 3/16/18.
//  Copyright © 2018 José Valderrama. All rights reserved.
//

import XCTest
@testable import Gnomes

class GnomesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Asynchronous test: success fast, failure slow
    func testValidBrastlewarkData() {
        // Given
        let promise = expectation(description: "Brastlewark has gnomes")
        
        // When
        APILayer.getBrastlewarkData { (brastlewarkObject, error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let brastlewark: Brastlewark = brastlewarkObject as? Brastlewark,
                let gnomes = brastlewark.gnomes, !gnomes.isEmpty {
                promise.fulfill()
            } else {
                XCTFail("There is no data")
            }
        }
        
        // Then
        waitForExpectations(timeout: 5, handler: nil)
    }
}
