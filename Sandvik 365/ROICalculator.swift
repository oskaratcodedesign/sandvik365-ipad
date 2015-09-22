//
//  ROICalculator.swift
//  Sandvik 365
//
//  Created by Karl Söderström on 10/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation
import UIKit

enum ChangeInput{
    case Increase
    case Decrease
    case Load
}

class ROIInput {
    
    func total() -> Double {
        preconditionFailure("This method must be overridden")
    }
    
    func maxTotal() -> Double {
        preconditionFailure("This method must be overridden")
    }
    
    func originalTotal() -> [UInt] {
        preconditionFailure("This method must be overridden")
    }
    
    func calculatedTotal() -> [UInt] {
        preconditionFailure("This method must be overridden")
    }
    
    func allTitles() -> [String] {
        preconditionFailure("This method must be overridden")
    }
    
    func changeInput(atIndex :Int, change : ChangeInput) -> String {
        preconditionFailure("This method must be overridden")
    }
}

class ROICalculator {
    let input: ROIInput
    
    init(input: ROIInput) {
        self.input = input
    }
}