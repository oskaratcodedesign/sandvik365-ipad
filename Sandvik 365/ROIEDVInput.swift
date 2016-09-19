//
//  ROIEDVInput.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 17/02/16.
//  Copyright © 2016 Commind. All rights reserved.
//
import Foundation
import UIKit

enum ROIEDVCostType {
    case extraCost
    case serviceCost
    case productivityLoss
}

enum ROIEDVInputValue {
    case extraCost(UInt)
    
    case repairHours(UInt)
    case numberOfTechnicians(UInt)
    case technicianCost(UInt)
    
    case standingStill(UInt)
    case capacity(UInt)
    case oreGrade(Double)
    case recoveryRate(Double)
    case orePrice(UInt)
    
    var title :String {
        switch self {
        case .extraCost:
            return NSLocalizedString("Average extra cost/breakdown", comment: "")
        case .repairHours:
            return NSLocalizedString("Total repair maintenance hours/breakdown", comment: "")
        case .numberOfTechnicians:
            return NSLocalizedString("Number of repair technicians/breakdown", comment: "")
        case .technicianCost:
            return NSLocalizedString("Average cost/technician", comment: "")
        case .standingStill:
            return NSLocalizedString("Total hours of crusher standing still/breakdown", comment: "")
        case .oreGrade:
            return NSLocalizedString("Ore grade", comment: "")
        case .capacity:
            return NSLocalizedString("Crushing capacity", comment: "")
        case .recoveryRate:
            return NSLocalizedString("Recovery rate", comment: "")
        case .orePrice:
            return NSLocalizedString("Selling price", comment: "")
        }
    }
    
    var value: Any {
        switch self {
        case .extraCost(let value):
            return value
        case .repairHours(let value):
            return value
        case .numberOfTechnicians(let value):
            return value
        case .technicianCost(let value):
            return value
        case .standingStill(let value):
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

class ROIEDVInput: ROICalculatorInput {
    var extraCost: ROIEDVInputValue = .extraCost(30000)
    var repairHours: ROIEDVInputValue = .repairHours(20)
    var numberOfTechnicians: ROIEDVInputValue = .numberOfTechnicians(2)
    var technicianCost: ROIEDVInputValue = .technicianCost(99)
    var standingStill: ROIEDVInputValue = .standingStill(20)
    
    var oreGrade: ROIEDVInputValue = .oreGrade(2.0) //%
    var capacity: ROIEDVInputValue = .capacity(1200) //m t/hr
    var recoveryRate: ROIEDVInputValue = .recoveryRate(85) //%
    var orePrice: ROIEDVInputValue = .orePrice(5500) //USD/m t
    
    var costTypes: Set<ROIEDVCostType> = Set<ROIEDVCostType>()
    var usePPM: Bool = false //otherwise percent
    
    func allInputs() -> [ROIEDVInputValue] {
        return [extraCost, repairHours, numberOfTechnicians, technicianCost, standingStill, oreGrade, capacity, recoveryRate, orePrice]
    }
    
    override func allTitles() -> [String] {
        return allInputs().flatMap({ $0.title })
    }
    
    func totalExtraCost() -> Double {
        if let ec = extraCost.value as? UInt {
            return Double(ec)
        }
        return 0
    }
    
    func totalServiceCostPerBreakDown() -> Double {
        if let rh = repairHours.value as? UInt, let nt = numberOfTechnicians.value as? UInt, let tc = technicianCost.value as? UInt{
            return Double(rh * nt * tc)
        }
        return 0
    }
    
    func totalProductivityLoss() -> Double {
        if let st = standingStill.value as? UInt, let ca = capacity.value as? UInt, let og = oreGrade.value as? Double, let rr = recoveryRate.value as? Double, let op = orePrice.value as? UInt{
            return Double(st) * Double(ca) * (Double(og)/100) * (Double(rr)/100) * Double(op)
        }
        return 0
    }
    
    override func total() -> Int? {
        var result:Double = 0
        for costType in self.costTypes {
            switch costType {
            case ROIEDVCostType.extraCost:
                result += totalExtraCost()
            case ROIEDVCostType.serviceCost:
                result += totalServiceCostPerBreakDown()
            case ROIEDVCostType.productivityLoss:
                result += totalProductivityLoss()
            }
        }
        
        if result > Double(Int.max) {
            return Int.max
        }
        return Int(result)
    }
    
    override func maxTotal() -> Double {
        return totalExtraCost() + totalServiceCostPerBreakDown() + totalProductivityLoss()
    }
    
    override func setInput(_ atIndex :Int, stringValue :String) -> Bool {
        let input = allInputs()[atIndex]
        switch input {
        case .extraCost:
            if let number = NumberFormatter().number(from: stringValue) {
                extraCost = .extraCost(number.uintValue)
                return true
            }
        case .repairHours:
            if let number = NumberFormatter().number(from: stringValue) {
                repairHours = .repairHours(number.uintValue)
                return true
            }
        case .numberOfTechnicians:
            if let number = NumberFormatter().number(from: stringValue) {
                numberOfTechnicians = .numberOfTechnicians(number.uintValue)
                return true
            }
        case .technicianCost:
            if let number = NumberFormatter().number(from: stringValue) {
                technicianCost = .technicianCost(number.uintValue)
                return true
            }
        case .standingStill:
            if let number = NumberFormatter().number(from: stringValue) {
                standingStill = .standingStill(number.uintValue)
                return true
            }
        case .oreGrade:
            if var number = NumberFormatter().formatterDecimalWith2Fractions().number(from: stringValue) {
                if usePPM {
                    number = NSNumber(value: number.doubleValue / 10000)
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
        case .extraCost:
            return NumberFormatter().string(from: NSNumber(value: extraCost.value as! UInt))
        case .repairHours:
            return NumberFormatter().string(from: NSNumber(value: repairHours.value as! UInt))
        case .numberOfTechnicians:
            return NumberFormatter().string(from: NSNumber(value: numberOfTechnicians.value as! UInt))
        case .technicianCost:
            return NumberFormatter().string(from: NSNumber(value: technicianCost.value as! UInt))
        case .standingStill:
            return NumberFormatter().string(from: NSNumber(value: standingStill.value as! UInt))
        case .oreGrade:
            var value = oreGrade.value as! Double
            if usePPM {
                value = 10000 * value
            }
            return NumberFormatter().formatterDecimalWith2Fractions().string(from: NSNumber(value: value))
        case .capacity:
            return NumberFormatter().string(from: NSNumber(value: capacity.value as! UInt))
        case .recoveryRate:
            return NumberFormatter().formatterDecimalWith2Fractions().string(from: NSNumber(value:recoveryRate.value as! Double))
        case .orePrice:
            return NumberFormatter().formatterDecimalWith2Fractions().string(from: NSNumber(value:orePrice.value as! UInt))
        }
    }
    
    override func getInputAbbreviation(_ atIndex :Int) -> InputAbbreviation? {
        let input = allInputs()[atIndex]
        switch input {
        case .extraCost:
            return InputAbbreviation.USD
        case .repairHours:
            return nil
        case .numberOfTechnicians:
            return nil
        case .technicianCost:
            return InputAbbreviation.USDHour
        case .standingStill:
            return nil
        case .oreGrade:
            return usePPM ? InputAbbreviation.PPM : InputAbbreviation.Percent
        case .capacity:
            return InputAbbreviation.TonPerHour
        case .recoveryRate:
            return InputAbbreviation.Percent
        case .orePrice:
            return usePPM ? InputAbbreviation.USDOunce : InputAbbreviation.USDton
        }
    }
    
    
    override func changeInput(_ atIndex :Int, change :ChangeInput) -> String {
        let input = allInputs()[atIndex]
        switch input {
        case .extraCost:
            if change != ChangeInput.load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.increase ? 1 : -1)
                if value >= 0 {
                    extraCost = .extraCost(UInt(value))
                }
            }
        case .repairHours:
            if change != ChangeInput.load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.increase ? 1 : -1)
                if value >= 0 {
                    repairHours = .repairHours(UInt(value))
                }
            }
        case .numberOfTechnicians:
            if change != ChangeInput.load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.increase ? 1 : -1)
                if value >= 0 {
                    numberOfTechnicians = .numberOfTechnicians(UInt(value))
                }
            }
        case .technicianCost:
            if change != ChangeInput.load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.increase ? 1 : -1)
                if value >= 0 {
                    technicianCost = .technicianCost(UInt(value))
                }
            }
        case .standingStill:
            if change != ChangeInput.load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.increase ? 1 : -1)
                if value >= 0 {
                    standingStill = .standingStill(UInt(value))
                }
            }
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
}
