//
//  ROICalculator.swift
//  Sandvik 365
//
//  Created by Karl Söderström on 10/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation
import UIKit

enum ROIService {
    case RampUp
    case ConditionInspection
    case MaintenancePlanning
    case Protective
}

enum ROIProduct {
    case Product1
    case Product2
    case Product3
    
    static let productImages = [
        Product1 : "sandvik_front_loader_"]
    static let productNames = [
        Product1 : "PT1500", Product2 : "PT3000"]
    
    static let allValues = [Product1, Product2, Product3]
    
    func infiniteNext() -> ROIProduct{
        if var index = find(ROIProduct.allValues, self) {
            index++
            if index < ROIProduct.allValues.count {
                return ROIProduct.allValues[index]
            }
        }
        return ROIProduct.allValues.first!
    }
    
    func infinitePrevious() -> ROIProduct{
        if var index = find(ROIProduct.allValues, self) {
            index--
            if index >= 0 {
                return ROIProduct.allValues[index]
            }
        }
        return ROIProduct.allValues.last!
    }
    
    func bigProductImage() -> UIImage? {
        if let imageName = ROIProduct.productImages[self] {
            return UIImage(named: imageName + "big")
        }
        return nil
    }
    
    func smallProductImage() -> UIImage? {
        if let imageName = ROIProduct.productImages[self] {
            return UIImage(named: imageName + "small")
        }
        return nil
    }
    
    func productName() -> String? {
        if let name = ROIProduct.productNames[self] {
            return name
        }
        return nil
    }
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
    var services: Set<ROIService>
    
    init(input: ROIInput, services: Set<ROIService>) {
        self.input = input
        self.services = services
    }
    
    func originalProfit() -> [UInt] {
        
        // TEMP
        return [0, 0, 0, 1000, 1000, 1000, 1000, 1000, 1000, 1000]
    }
    
    func calculatedProfit() -> [UInt] {
        
        // TEMP
        var multiplier = 1.0
        for service in services {
            multiplier += 0.25
        }
        var values: [UInt] = [0, 0, 1500, 1500, 1500, 1500, 1500, 1500, 1500, 1500]
        for var i = 0; i < values.count; ++i {
            values[i] = UInt(Double(values[i]) * multiplier)
        }
        return values
    }
}