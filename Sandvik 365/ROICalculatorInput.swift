//
//  ROICalculator.swift
//  Sandvik 365
//
//  Created by Karl Söderström on 10/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation
import UIKit

class ROICalculatorInput: SelectionInput {
    
    func total() -> Int {
        preconditionFailure("This method must be overridden")
    }
    
    func maxTotal() -> Double {
        preconditionFailure("This method must be overridden")
    }
    
    func originalTotal() -> [Int] {
        preconditionFailure("This method must be overridden")
    }
    
    func calculatedTotal() -> [Int] {
        preconditionFailure("This method must be overridden")
    }
    
    func graphScale() -> CGFloat {
        preconditionFailure("This method must be overridden")
    }
}