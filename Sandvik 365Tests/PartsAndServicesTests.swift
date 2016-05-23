//
//  PartsAndServicesTests.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 26/04/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import XCTest
@testable import Sandvik_365

class PartsAndServicesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEnum() {
        // This is an example of a performance test case.
        //let t = BusinessType(.All)
        let all = [BusinessType.CrusherAndScreening, BusinessType.ExplorationDrillRigs, BusinessType.ExplorationDrillRigs, BusinessType.MechanicalCutting, BusinessType.SurfaceDrilling, BusinessType.All]
        let count = all.count
        let last = Int(BusinessType.All.rawValue)
        XCTAssert(last == count, "All is not last")
    }
    
}
