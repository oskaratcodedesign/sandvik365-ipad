//
//  ROICrusherCalculator.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 16/09/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation
import UIKit

enum ROICrusherService: UInt {
    case RampUp = 14
    case ConditionInspection = 1
    case MaintenancePlanning = 7
    //case Protective
}

enum OperationType: String {
    case New = "New"
    case Established = "Established"
}

enum ROICrusherInputValue {
    case Operation(OperationType)
    case Capacity(UInt)
    case OreGrade(Double)
    case RecoveryRate(Double)
    case OrePrice(UInt)

    var title :String {
        switch self {
        case Operation:
            return NSLocalizedString("Operation", comment: "")
        case OreGrade:
            return NSLocalizedString("Ore grade", comment: "")
        case Capacity:
            return NSLocalizedString("Crushing capacity", comment: "")
        case RecoveryRate:
            return NSLocalizedString("Recovery rate", comment: "")
        case OrePrice:
            return NSLocalizedString("Market price", comment: "")
        }
    }
    
    var value: Any {
        switch self {
        case Operation(let value):
            return value
        case OreGrade(let value):
            return value
        case Capacity(let value):
            return value
        case RecoveryRate(let value):
            return value
        case OrePrice(let value):
            return value
        }
    }
}

class ROICrusherInput: ROICalculatorInput {
    var operation: ROICrusherInputValue = .Operation(OperationType.New)
    var oreGrade: ROICrusherInputValue = .OreGrade(2.0) //%
    var capacity: ROICrusherInputValue = .Capacity(1200) //m t/hr
    var recoveryRate: ROICrusherInputValue = .RecoveryRate(85) //%
    var orePrice: ROICrusherInputValue = .OrePrice(5500) //USD/m t
    var services: Set<ROICrusherService> = Set<ROICrusherService>()
    var usePPM: Bool = false //otherwise percent
    let months: UInt = 12
    let startMonth: UInt = 3
    
    func allInputs() -> [ROICrusherInputValue] {
        return [operation, capacity, oreGrade, recoveryRate, orePrice]
    }
    
    override func allTitles() -> [String] {
        return allInputs().flatMap({ $0.title })
    }
    
    override func setInput(atIndex :Int, stringValue :String) -> Bool {
        let input = allInputs()[atIndex]
        switch input {
        case .Operation:
            return false
        case .OreGrade:
            if var number = NSNumberFormatter().formatterDecimalWith2Fractions().numberFromString(stringValue) {
                if usePPM {
                    number = number.doubleValue/10000
                }
                oreGrade = .OreGrade(number.doubleValue)
                return true
            }
        case .Capacity:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                capacity = .Capacity(number.unsignedLongValue)
                return true
            }
        case .RecoveryRate:
            if let number = NSNumberFormatter().formatterDecimalWith2Fractions().numberFromString(stringValue) {
                recoveryRate = .RecoveryRate(number.doubleValue)
                return true
            }
        case .OrePrice:
            if let number = NSNumberFormatter().formatterDecimalWith2Fractions().numberFromString(stringValue) {
                orePrice = .OrePrice(number.unsignedLongValue)
                return true
            }
        }
        
        return false
    }
    
    override func getInputAsString(atIndex :Int) -> String? {
        let input = allInputs()[atIndex]
        switch input {
        case .Operation:
            return nil
        case .OreGrade:
            var value = oreGrade.value as! Double
            if usePPM {
                value = 10000 * value
            }
            return NSNumberFormatter().formatterDecimalWith2Fractions().stringFromNumber(value)
        case .Capacity:
            return NSNumberFormatter().stringFromNumber(capacity.value as! UInt)
        case .RecoveryRate:
            return NSNumberFormatter().formatterDecimalWith2Fractions().stringFromNumber(recoveryRate.value as! Double)
        case .OrePrice:
            return NSNumberFormatter().formatterDecimalWith2Fractions().stringFromNumber(orePrice.value as! UInt)
        }
    }
    
    override func getInputAbbreviation(atIndex :Int) -> InputAbbreviation? {
        let input = allInputs()[atIndex]
        switch input {
        case .Operation:
            return nil
        case .OreGrade:
            return usePPM ? InputAbbreviation.PPM : InputAbbreviation.Percent
        case .Capacity:
            return InputAbbreviation.MillionTonPerDay
        case .RecoveryRate:
            return InputAbbreviation.Percent
        case .OrePrice:
            return usePPM ? InputAbbreviation.USDOunce : InputAbbreviation.USDton
        }
    }

    
    override func changeInput(atIndex :Int, change :ChangeInput) -> String {
        let input = allInputs()[atIndex]
        switch input {
        case .Operation:
            let value = operation.value as! OperationType
            if change != ChangeInput.Load {
                if value == .New {
                    operation = .Operation(.Established)
                }
                else {
                    operation = .Operation(.New)
                }
                self.services.removeAll() //clear when operation change
            }
            return (operation.value as! OperationType).rawValue
        case .OreGrade:
            if change != ChangeInput.Load {
                var value = oreGrade.value as! Double
                
                if usePPM {
                    value = value * 10000
                    value = value + (change == ChangeInput.Increase ? 1 : 1)
                    value = value/10000
                }
                else {
                    value = value + (change == ChangeInput.Increase ? 0.10 : -0.10)
                }
                
                if value >= 0 {
                    oreGrade = .OreGrade(value)
                }
            }
        case .Capacity:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    capacity = .Capacity(UInt(value))
                }
            }
        case .RecoveryRate:
            if change != ChangeInput.Load {
                let value = input.value as! Double + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    recoveryRate = .RecoveryRate(value)
                }
            }
        case .OrePrice:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    orePrice = .OrePrice(UInt(value))
                }
            }
        }
        return getInputAsString(atIndex)!
    }
    
    override func total() -> Int {
        var result: Int = 0
        let tonnage = capacity.value as! UInt
        let oregrade = oreGrade.value as! Double
        let recoverrate = recoveryRate.value as! Double
        let marketPrice = orePrice.value as! UInt
        
        if let service = services.first {
            let res = (Double(tonnage) * (Double(oregrade)/100) * (Double(recoverrate)/100) * Double(marketPrice)) * Double(service.rawValue)
            if res > Double(Int.max) {
                result = Int.max
            }
            else {
                result = Int(res)
            }
        }
        return result
    }
    
    override func maxTotal() -> Double {
        let currentServices = services
        services = [.RampUp]
        let result = Double(total())
        services = currentServices
        return result
    }
    
    override func graphScale() -> CGFloat {
        return 2
    }
}