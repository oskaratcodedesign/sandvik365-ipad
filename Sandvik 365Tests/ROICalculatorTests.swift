//
//  ROICalculatorTests.swift
//  Sandvik 365
//
//  Created by Karl Söderström on 10/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation
import XCTest

class ROICalculatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOriginalProfitProduct1() {
        var input = ROIInput()
        input.product = .Product1
        input.numberOfProducts = 1
        input.oreGrade = 30
        input.efficiency = 30
        input.price = 30
        let profit = ROICalculator(input: input, services: []).originalProfit()
        XCTAssert(profit.count == 10)
        XCTAssert(true, "Pass")
    }
}
