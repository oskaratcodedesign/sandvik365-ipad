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
    case ExtraCost
    case ServiceCost
    case ProductivityLoss
}

enum ROIEDVInputValue {
    case BreakDowns(UInt)
    case ExtraCost(UInt)
    
    case RepairHours(UInt)
    case NumberOfTechnicians(UInt)
    case TechnicianCost(UInt)
    
    case StandingStill(UInt)
    case Capacity(UInt)
    case OreGrade(Double)
    case RecoveryRate(Double)
    case OrePrice(UInt)
    
    var title :String {
        switch self {
        case BreakDowns:
            return NSLocalizedString("Unplanned crusher breakdowns", comment: "")
        case ExtraCost:
            return NSLocalizedString("Average extra cost/breakdown", comment: "")
        case RepairHours:
            return NSLocalizedString("Total repair maintenance hours", comment: "")
        case NumberOfTechnicians:
            return NSLocalizedString("Number of repair technicians", comment: "")
        case TechnicianCost:
            return NSLocalizedString("Average cost/technician", comment: "")
        case StandingStill:
            return NSLocalizedString("Total hours of crusher standing still", comment: "")
        case OreGrade:
            return NSLocalizedString("Ore grade", comment: "")
        case Capacity:
            return NSLocalizedString("Crushing capacity", comment: "")
        case RecoveryRate:
            return NSLocalizedString("Recovery rate", comment: "")
        case OrePrice:
            return NSLocalizedString("Selling price", comment: "")
        }
    }
    
    var value: Any {
        switch self {
        case BreakDowns(let value):
            return value
        case ExtraCost(let value):
            return value
        case RepairHours(let value):
            return value
        case NumberOfTechnicians(let value):
            return value
        case TechnicianCost(let value):
            return value
        case StandingStill(let value):
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

class ROIEDVInput: ROICalculatorInput {
    var breakDowns: ROIEDVInputValue = .BreakDowns(1)
    var extraCost: ROIEDVInputValue = .ExtraCost(0)
    var repairHours: ROIEDVInputValue = .RepairHours(0)
    var numberOfTechnicians: ROIEDVInputValue = .NumberOfTechnicians(0)
    var technicianCost: ROIEDVInputValue = .TechnicianCost(0)
    var standingStill: ROIEDVInputValue = .StandingStill(0)
    
    var oreGrade: ROIEDVInputValue = .OreGrade(2.0) //%
    var capacity: ROIEDVInputValue = .Capacity(1200) //m t/hr
    var recoveryRate: ROIEDVInputValue = .RecoveryRate(85) //%
    var orePrice: ROIEDVInputValue = .OrePrice(5500) //USD/m t
    
    var costType: ROIEDVCostType?
    var usePPM: Bool = false //otherwise percent
    
    func allInputs() -> [ROIEDVInputValue] {
        return [breakDowns, extraCost, repairHours, numberOfTechnicians, technicianCost, standingStill, oreGrade, capacity, recoveryRate, orePrice]
    }
    
    override func allTitles() -> [String] {
        return allInputs().flatMap({ $0.title })
    }
    
    private func totalExtraCost() -> Double {
        if let bd = breakDowns.value as? UInt, ec = extraCost.value as? UInt {
            return Double(bd * ec)
        }
        return 0
    }
    
    private func totalServiceCostPerBreakDown() -> Double {
        if let rh = repairHours.value as? UInt, nt = numberOfTechnicians.value as? UInt, tc = technicianCost.value as? UInt{
            return Double(rh * nt * tc)
        }
        return 0
    }
    
    private func totalServiceCostPerYear() -> Double {
        if let bd = breakDowns.value as? UInt {
            return Double(bd) * totalServiceCostPerBreakDown()
        }
        return 0
    }
    
    private func totalProductivityLoss() -> Double {
        if let st = standingStill.value as? UInt, ca = capacity.value as? UInt, og = oreGrade.value as? Double, rr = recoveryRate.value as? Double, op = orePrice.value as? UInt{
            return Double(st) * Double(ca) * (Double(og)/100) * (Double(rr)/100) * Double(op)
        }
        return 0
    }
    
    override func total() -> Int? {
        var result:Double = 0
        if let costType = self.costType {
            switch costType {
            case ROIEDVCostType.ExtraCost:
                result = totalExtraCost()
            case ROIEDVCostType.ServiceCost:
                result = totalServiceCostPerYear()
            case ROIEDVCostType.ProductivityLoss:
                result = totalProductivityLoss()
            }
        }
        
        if result > Double(Int.max) {
            return Int.max
        }
        return Int(result)
    }
    
    override func maxTotal() -> Double {
        return totalExtraCost() + totalServiceCostPerYear() + totalProductivityLoss()
    }
    
    override func setInput(atIndex :Int, stringValue :String) -> Bool {
        let input = allInputs()[atIndex]
        switch input {
        case .BreakDowns:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                breakDowns = .BreakDowns(number.unsignedLongValue)
                return true
            }
        case .ExtraCost:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                extraCost = .ExtraCost(number.unsignedLongValue)
                return true
            }
        case .RepairHours:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                repairHours = .RepairHours(number.unsignedLongValue)
                return true
            }
        case .NumberOfTechnicians:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                numberOfTechnicians = .NumberOfTechnicians(number.unsignedLongValue)
                return true
            }
        case .TechnicianCost:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                technicianCost = .TechnicianCost(number.unsignedLongValue)
                return true
            }
        case .StandingStill:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                standingStill = .StandingStill(number.unsignedLongValue)
                return true
            }
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
        case .BreakDowns:
            return NSNumberFormatter().stringFromNumber(breakDowns.value as! UInt)
        case .ExtraCost:
            return NSNumberFormatter().stringFromNumber(extraCost.value as! UInt)
        case .RepairHours:
            return NSNumberFormatter().stringFromNumber(repairHours.value as! UInt)
        case .NumberOfTechnicians:
            return NSNumberFormatter().stringFromNumber(numberOfTechnicians.value as! UInt)
        case .TechnicianCost:
            return NSNumberFormatter().stringFromNumber(technicianCost.value as! UInt)
        case .StandingStill:
            return NSNumberFormatter().stringFromNumber(standingStill.value as! UInt)
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
        case .BreakDowns:
            return InputAbbreviation.Year
        case .ExtraCost:
            return InputAbbreviation.USD
        case .RepairHours:
            return nil
        case .NumberOfTechnicians:
            return nil
        case .TechnicianCost:
            return InputAbbreviation.USDHour
        case .StandingStill:
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
        case .BreakDowns:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    breakDowns = .BreakDowns(UInt(value))
                }
            }
        case .ExtraCost:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    extraCost = .ExtraCost(UInt(value))
                }
            }
        case .RepairHours:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    repairHours = .RepairHours(UInt(value))
                }
            }
        case .NumberOfTechnicians:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    numberOfTechnicians = .NumberOfTechnicians(UInt(value))
                }
            }
        case .TechnicianCost:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    technicianCost = .TechnicianCost(UInt(value))
                }
            }
        case .StandingStill:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    standingStill = .StandingStill(UInt(value))
                }
            }
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
}