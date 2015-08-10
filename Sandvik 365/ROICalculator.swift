//
//  ROICalculator.swift
//  Sandvik 365
//
//  Created by Karl Söderström on 10/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation

enum ROIService {
    case RampUp
    case ConditionInspection
    case MaintenancePlanning
    case Protective
}

enum ROIProduct {
    case Product1
    case Product2
}

class ROIInput {
    var product: ROIProduct = .Product1
    var numberOfProducts: UInt = 0
    var oreGrade: UInt = 0
    var efficiency: UInt = 0
    var price: UInt = 0
}

class ROICalculator {
    let input: ROIInput
    let services: [ROIService]
    
    init(input: ROIInput, services: [ROIService]) {
        self.input = input
        self.services = services
    }
    
    func originalProfit() -> [UInt] {
        
        return []
    }
    
    func calculatedProfit() -> [UInt] {
        
        return []
    }
}