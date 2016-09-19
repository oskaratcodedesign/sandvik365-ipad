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
    case wearLife
    case costPerHour
    case revenueLoss
    case availability
    case maintenanceTime
    
    var percentages: [Double] {
        switch self {
        case .wearLife:
            return [100, 140, 215]
        case .costPerHour:
            return [100, 80, 60]
        case .revenueLoss:
            return [100, 30, 7]
        case .availability:
            return [96, 98, 99.55]
        case .maintenanceTime:
            return [100, 65, 25]
        }
    }
}

enum ROIGetInputValue {
    case loaders(UInt)
    case lipsUsed(UInt)
    case lipReplacementCost(Double)
    
    var title :String {
        switch self {
        case .loaders:
            return NSLocalizedString("Number of loaders", comment: "")
        case .lipsUsed:
            return NSLocalizedString("Number of lips/cutting edges used during 4000 h/loader", comment: "")
        case .lipReplacementCost:
            return NSLocalizedString("Lip replacement cost/change", comment: "")
        }
    }
    
    var value: Any {
        switch self {
        case .loaders(let value):
            return value
        case .lipsUsed(let value):
            return value
        case .lipReplacementCost(let value):
            return value
        }
    }
}

class ROIGetInput: ROICalculatorInput {
    var loaders: ROIGetInputValue = .loaders(1)
    var lipsUsed: ROIGetInputValue = .lipsUsed(6)
    var lipReplacementCost: ROIGetInputValue = .lipReplacementCost(2500)
    var calculationType: ROIGetCalculationType?
    
    func allInputs() -> [ROIGetInputValue] {
        return [loaders, lipsUsed, lipReplacementCost]
    }
    
    override func allTitles() -> [String] {
        return allInputs().flatMap({ $0.title })
    }
    
    override func total() -> Int? {
        //(6 x 2500)+(13 000 x 2)
        /*if calculationType == .CostPerHour*/
        if let loaders = loaders.value as? UInt, let lipsUsed = lipsUsed.value as? UInt, let lipReplacementCost = lipReplacementCost.value as? Double{
            let res = Double(loaders) * (Double(lipsUsed) * lipReplacementCost)
            if res > Double(Int.max) {
                return Int.max
            }
            else {
                return Int(res)
            }
        }
        return nil
    }
    
    override func maxTotal() -> Double {
        return 0
    }
    
    override func setInput(_ atIndex :Int, stringValue :String) -> Bool {
        let input = allInputs()[atIndex]
        switch input {
        case .loaders:
            if let number = NumberFormatter().number(from: stringValue) {
                loaders = .loaders(number.uintValue)
                return true
            }
        case .lipsUsed:
            if let number = NumberFormatter().number(from: stringValue) {
                lipsUsed = .lipsUsed(number.uintValue)
                return true
            }
        case .lipReplacementCost:
            if let number = NumberFormatter().formatterDecimalWith2Fractions().number(from: stringValue) {
                lipReplacementCost = .lipReplacementCost(number.doubleValue)
                return true
            }
        }
        
        return false
    }
    
    override func getInputAsString(_ atIndex :Int) -> String? {
        let input = allInputs()[atIndex]
        switch input {
        case .loaders:
            return NumberFormatter().string(from: NSNumber(loaders.value as! UInt))
        case .lipsUsed:
            return NumberFormatter().string(from: NSNumber(lipsUsed.value as! UInt))
        case .lipReplacementCost:
            return NumberFormatter().formatterDecimalWith2Fractions().string(from: lipReplacementCost.value as! Double)
        }
    }
    
    override func getInputAbbreviation(_ atIndex :Int) -> InputAbbreviation? {
        let input = allInputs()[atIndex]
        switch input {
        case .loaders:
            return nil
        case .lipsUsed:
            return nil
        case .lipReplacementCost:
            return InputAbbreviation.USD
        }
    }
    
    
    override func changeInput(_ atIndex :Int, change :ChangeInput) -> String {
        let input = allInputs()[atIndex]
        switch input {
        case .loaders:
            if change != ChangeInput.load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.increase ? 1 : -1)
                if value >= 0 {
                    loaders = .loaders(UInt(value))
                }
            }
        case .lipsUsed:
            if change != ChangeInput.load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.increase ? 1 : -1)
                if value >= 0 {
                    lipsUsed = .lipsUsed(UInt(value))
                }
            }
        case .lipReplacementCost:
            if change != ChangeInput.load {
                let value = input.value as! Double + (change == ChangeInput.increase ? 1 : -1)
                if value >= 0 {
                    lipReplacementCost = .lipReplacementCost(value)
                }
            }
        }
        return getInputAsString(atIndex)!
    }
    
}
