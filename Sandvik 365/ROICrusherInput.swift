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
    case rampUp = 14
    case conditionInspection = 1
    case maintenancePlanning = 7
    //case Protective
}

enum OperationType: String {
    case New = "New"
    case Established = "Established"
}

enum ROICrusherInputValue {
    case operation(OperationType)
    case capacity(UInt)
    case oreGrade(Double)
    case recoveryRate(Double)
    case orePrice(UInt)

    var title :String {
        switch self {
        case .operation:
            return NSLocalizedString("Operation", comment: "")
        case .oreGrade:
            return NSLocalizedString("Ore grade", comment: "")
        case .capacity:
            return NSLocalizedString("Crushing capacity", comment: "")
        case .recoveryRate:
            return NSLocalizedString("Recovery rate", comment: "")
        case .orePrice:
            return NSLocalizedString("Market price", comment: "")
        }
    }
    
    var value: Any {
        switch self {
        case .operation(let value):
            return value
        case .oreGrade(let value):
            return value
        case .capacity(let value):
            return value
        case .recoveryRate(let value):
            return value
        case .orePrice(let value):
            return value
        }
    }
}

class ROICrusherInput: ROICalculatorInput {
    var operation: ROICrusherInputValue = .operation(OperationType.New)
    var oreGrade: ROICrusherInputValue = .oreGrade(2.0) //%
    var capacity: ROICrusherInputValue = .capacity(1200) //m t/hr
    var recoveryRate: ROICrusherInputValue = .recoveryRate(85) //%
    var orePrice: ROICrusherInputValue = .orePrice(5500) //USD/m t
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
    
    override func setInput(_ atIndex :Int, stringValue :String) -> Bool {
        let input = allInputs()[atIndex]
        switch input {
        case .operation:
            return false
        case .oreGrade:
            if var number = NumberFormatter().formatterDecimalWith2Fractions().number(from: stringValue) {
                if usePPM {
                    number = number.doubleValue/10000
                }
                oreGrade = .oreGrade(number.doubleValue)
                return true
            }
        case .capacity:
            if let number = NumberFormatter().number(from: stringValue) {
                capacity = .capacity(number.uintValue)
                return true
            }
        case .recoveryRate:
            if let number = NumberFormatter().formatterDecimalWith2Fractions().number(from: stringValue) {
                recoveryRate = .recoveryRate(number.doubleValue)
                return true
            }
        case .orePrice:
            if let number = NumberFormatter().formatterDecimalWith2Fractions().number(from: stringValue) {
                orePrice = .orePrice(number.uintValue)
                return true
            }
        }
        
        return false
    }
    
    override func getInputAsString(_ atIndex :Int) -> String? {
        let input = allInputs()[atIndex]
        switch input {
        case .operation:
            return nil
        case .oreGrade:
            var value = oreGrade.value as! Double
            if usePPM {
                value = 10000 * value
            }
            return NumberFormatter().formatterDecimalWith2Fractions().string(from: value)
        case .capacity:
            return NumberFormatter().string(from: NSNumber(capacity.value as! UInt))
        case .recoveryRate:
            return NumberFormatter().formatterDecimalWith2Fractions().string(from: recoveryRate.value as! Double)
        case .orePrice:
            return NumberFormatter().formatterDecimalWith2Fractions().string(from: orePrice.value as! UInt)
        }
    }
    
    override func getInputAbbreviation(_ atIndex :Int) -> InputAbbreviation? {
        let input = allInputs()[atIndex]
        switch input {
        case .operation:
            return nil
        case .oreGrade:
            return usePPM ? InputAbbreviation.PPM : InputAbbreviation.Percent
        case .capacity:
            return InputAbbreviation.TonPerDay
        case .recoveryRate:
            return InputAbbreviation.Percent
        case .orePrice:
            return usePPM ? InputAbbreviation.USDOunce : InputAbbreviation.USDton
        }
    }

    
    override func changeInput(_ atIndex :Int, change :ChangeInput) -> String {
        let input = allInputs()[atIndex]
        switch input {
        case .operation:
            let value = operation.value as! OperationType
            if change != ChangeInput.load {
                if value == .New {
                    operation = .operation(.Established)
                }
                else {
                    operation = .operation(.New)
                }
                self.services.removeAll() //clear when operation change
            }
            return (operation.value as! OperationType).rawValue
        case .oreGrade:
            if change != ChangeInput.load {
                var value = oreGrade.value as! Double
                
                if usePPM {
                    value = value * 10000
                    value = value + (change == ChangeInput.increase ? 1 : 1)
                    value = value/10000
                }
                else {
                    value = value + (change == ChangeInput.increase ? 0.10 : -0.10)
                }
                
                if value >= 0 {
                    oreGrade = .oreGrade(value)
                }
            }
        case .capacity:
            if change != ChangeInput.load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.increase ? 1 : -1)
                if value >= 0 {
                    capacity = .capacity(UInt(value))
                }
            }
        case .recoveryRate:
            if change != ChangeInput.load {
                let value = input.value as! Double + (change == ChangeInput.increase ? 1 : -1)
                if value >= 0 {
                    recoveryRate = .recoveryRate(value)
                }
            }
        case .orePrice:
            if change != ChangeInput.load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.increase ? 1 : -1)
                if value >= 0 {
                    orePrice = .orePrice(UInt(value))
                }
            }
        }
        return getInputAsString(atIndex)!
    }
    
    override func total() -> Int? {
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
        services = [.rampUp]
        var result = 0.0
        if let total = total() {
            result = Double(total)
        }
        services = currentServices
        return result
    }
    
    override func graphScale() -> CGFloat {
        return 2
    }
}
