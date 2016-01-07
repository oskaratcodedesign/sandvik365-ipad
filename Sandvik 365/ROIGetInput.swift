//
//  ROIGetInput.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 21/12/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation
import UIKit

enum ROIGetCalculationType {
    case WearLife
    case CostPerHour
    case RevenueLoss
    case Availability
    case MaintenanceTime
    
    var percentages: [Double] {
        switch self {
        case WearLife:
            return [100, 140, 215]
        case CostPerHour:
            return [100, 80, 60]
        case RevenueLoss:
            return [100, 30, 7]
        case Availability:
            return [96, 98, 99.55]
        case MaintenanceTime:
            return [100, 65, 25]
        }
    }
}

enum ROIGetInputValue {
    case Loaders(UInt)
    case LipsUsed(UInt)
    case LipReplacementCost(Double)
    case ServiceCost(Double)
    
    var title :String {
        switch self {
        case Loaders:
            return NSLocalizedString("Number of loaders", comment: "")
        case LipsUsed:
            return NSLocalizedString("Number of lips used/worn out during 4000h", comment: "")
        case LipReplacementCost:
            return NSLocalizedString("Lip replacement cost/change", comment: "")
        case ServiceCost:
            return NSLocalizedString("Service cost/2000h", comment: "")
        }
    }
    
    var value: Any {
        switch self {
        case Loaders(let value):
            return value
        case LipsUsed(let value):
            return value
        case LipReplacementCost(let value):
            return value
        case ServiceCost(let value):
            return value
        }
    }
}

class ROIGetInput: ROICalculatorInput {
    var loaders: ROIGetInputValue = .Loaders(1)
    var lipsUsed: ROIGetInputValue = .LipsUsed(6)
    var lipReplacementCost: ROIGetInputValue = .LipReplacementCost(2500)
    var serviceCost: ROIGetInputValue = .ServiceCost(13000)
    var calculationType: ROIGetCalculationType?
    
    func allInputs() -> [ROIGetInputValue] {
        return [loaders, lipsUsed, lipReplacementCost, serviceCost]
    }
    
    override func allTitles() -> [String] {
        return allInputs().flatMap({ $0.title })
    }
    
    override func total() -> Int? {
        //(6 x 2500)+(13 000 x 2)
        if calculationType == .CostPerHour {
            if let loaders = loaders.value as? UInt, let lipsUsed = lipsUsed.value as? UInt, let lipReplacementCost = lipReplacementCost.value as? Double, let serviceCost = serviceCost.value as? Double {
                let res = Double(loaders) * (Double(lipsUsed) * lipReplacementCost) + (serviceCost * 2)
                if res > Double(Int.max) {
                    return Int.max
                }
                else {
                    return Int(res)
                }
            }
        }
        return nil
    }
    
    override func maxTotal() -> Double {
        return 0
    }
    
    override func setInput(atIndex :Int, stringValue :String) -> Bool {
        let input = allInputs()[atIndex]
        switch input {
        case .Loaders:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                loaders = .Loaders(number.unsignedLongValue)
                return true
            }
        case .LipsUsed:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                lipsUsed = .LipsUsed(number.unsignedLongValue)
                return true
            }
        case .LipReplacementCost:
            if let number = NSNumberFormatter().formatterDecimalWith2Fractions().numberFromString(stringValue) {
                lipReplacementCost = .LipReplacementCost(number.doubleValue)
                return true
            }
        case .ServiceCost:
            if let number = NSNumberFormatter().formatterDecimalWith2Fractions().numberFromString(stringValue) {
                serviceCost = .ServiceCost(number.doubleValue)
                return true
            }
        }
        
        return false
    }
    
    override func getInputAsString(atIndex :Int) -> String? {
        let input = allInputs()[atIndex]
        switch input {
        case .Loaders:
            return NSNumberFormatter().stringFromNumber(loaders.value as! UInt)
        case .LipsUsed:
            return NSNumberFormatter().stringFromNumber(lipsUsed.value as! UInt)
        case .LipReplacementCost:
            return NSNumberFormatter().formatterDecimalWith2Fractions().stringFromNumber(lipReplacementCost.value as! Double)
        case .ServiceCost:
            return NSNumberFormatter().formatterDecimalWith2Fractions().stringFromNumber(serviceCost.value as! Double)
        }
    }
    
    override func getInputAbbreviation(atIndex :Int) -> InputAbbreviation? {
        let input = allInputs()[atIndex]
        switch input {
        case .Loaders:
            return nil
        case .LipsUsed:
            return nil
        case .LipReplacementCost:
            return InputAbbreviation.USD
        case .ServiceCost:
            return InputAbbreviation.USD
        }
    }
    
    
    override func changeInput(atIndex :Int, change :ChangeInput) -> String {
        let input = allInputs()[atIndex]
        switch input {
        case .Loaders:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    loaders = .Loaders(UInt(value))
                }
            }
        case .LipsUsed:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    lipsUsed = .LipsUsed(UInt(value))
                }
            }
        case .LipReplacementCost:
            if change != ChangeInput.Load {
                let value = input.value as! Double + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    lipReplacementCost = .LipReplacementCost(value)
                }
            }
        case .ServiceCost:
            if change != ChangeInput.Load {
                let value = input.value as! Double + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    serviceCost = .ServiceCost(value)
                }
            }
        }
        return getInputAsString(atIndex)!
    }
    
}