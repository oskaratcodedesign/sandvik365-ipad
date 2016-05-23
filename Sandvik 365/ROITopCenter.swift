//
//  ROITopCenter.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 17/03/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import Foundation
import UIKit

enum ROITopCenterCostType {
    case SavedBitCost
    case SavedGrindingCost
    case SavedValueCost
}

enum ROITopCenterInputValue {
    case DrillRigCost(Double)
    case RegrindCost(Double)
    case BitChangeTime(Double)
    case DrilledMeters(UInt)
    case BitPrice(Double)
    case ServiceLife(UInt)
    case NoOfBitRegrinds(Double)
    
    var title :String {
        switch self {
        case DrillRigCost:
            return NSLocalizedString("Drill rig cost", comment: "")
        case RegrindCost:
            return NSLocalizedString("Regrind cost", comment: "")
        case BitChangeTime:
            return NSLocalizedString("Time to change bit", comment: "")
        case DrilledMeters:
            return NSLocalizedString("Drill meters per year", comment: "")
        case BitPrice:
            return NSLocalizedString("Bit price for current bit", comment: "")
        case ServiceLife:
            return NSLocalizedString("Bit service life for current bit", comment: "")
        case NoOfBitRegrinds:
            return NSLocalizedString("Number of regrinds/current bit", comment: "")
        }
    }
    
    var description :String {
        switch self {
        case DrillRigCost, RegrindCost, BitPrice, ServiceLife, NoOfBitRegrinds:
            return ""
        case BitChangeTime:
            return NSLocalizedString("State the time required to change each bit. I.e. total time divided by two if two bits are changed.", comment: "")
        case DrilledMeters:
            return NSLocalizedString("For all drill rigs using this bit", comment: "")
        }
    }
    
    var value: Any {
        switch self {
        case DrillRigCost(let value):
            return value
        case RegrindCost(let value):
            return value
        case BitChangeTime(let value):
            return value
        case DrilledMeters(let value):
            return value
        case BitPrice(let value):
            return value
        case ServiceLife(let value):
            return value
        case NoOfBitRegrinds(let value):
            return value
        }
    }
}

class ROITopCenterInput: ROICalculatorInput {
    var drillRigCost: ROITopCenterInputValue = .DrillRigCost(350)
    var regrindCost: ROITopCenterInputValue = .RegrindCost(4.0)
    var bitChangeTime: ROITopCenterInputValue = .BitChangeTime(3.0)
    var drilledMeters: ROITopCenterInputValue = .DrilledMeters(500000)
    var bitPrice: ROITopCenterInputValue = .BitPrice(50)
    var serviceLife: ROITopCenterInputValue = .ServiceLife(200)
    var noOfBitRegrinds: ROITopCenterInputValue = .NoOfBitRegrinds(3.0)
    
    var costTypes: Set<ROITopCenterCostType> = Set<ROITopCenterCostType>()
    
    func allInputs() -> [ROITopCenterInputValue] {
        return [drillRigCost, regrindCost, bitChangeTime, drilledMeters, bitPrice, serviceLife, noOfBitRegrinds]
    }
    
    override func allTitles() -> [String] {
        return allInputs().flatMap({ $0.title })
    }
    
    func allDescriptions() -> [String] {
        return allInputs().flatMap({ $0.description })
    }

    func savedBitCost() -> Double {
        if let dm = drilledMeters.value as? UInt, sl = serviceLife.value as? UInt,
        bp = bitPrice.value as? Double  {
            let v1 = Double(dm) / Double(sl) * bp
            let v2 = 1.2 / 1.5 * Double(dm) / Double(sl) * bp
            return v1 - v2
        }
        return 0
    }
    
    func savedGrindingCost() -> Double {
        if let dm = drilledMeters.value as? UInt, rc = regrindCost.value as? Double, sl = serviceLife.value as? UInt, nr = noOfBitRegrinds.value as? Double  {
            return rc / 3 * Double(dm) / Double(sl) * nr
        }
        return 0
    }
    
    func timeSavedCost() -> Double {
        if let bc = bitChangeTime.value as? Double, dm = drilledMeters.value as? UInt, sl = serviceLife.value as? UInt, nr = noOfBitRegrinds.value as? Double  {
            return bc / 3 * Double(dm) / Double(sl) * (nr + 1) / 60
        }
        return 0
    }
    
    func savedValueCost() -> Double {
        if let dr = drillRigCost.value as? Double {
            return timeSavedCost() * dr
        }
        return 0
    }
    
    override func total() -> Int? {
        var result:Double = 0
        for costType in self.costTypes {
            switch costType {
            case ROITopCenterCostType.SavedBitCost:
                result += savedBitCost()
            case ROITopCenterCostType.SavedGrindingCost:
                result += savedGrindingCost()
            case ROITopCenterCostType.SavedValueCost:
                result += savedValueCost()
            }
        }
        
        if result > Double(Int.max) {
            return Int.max
        }
        return Int(result)
    }
    
    override func maxTotal() -> Double {
        return savedBitCost() + savedGrindingCost() + savedValueCost()
    }
    
    override func setInput(atIndex :Int, stringValue :String) -> Bool {
        let input = allInputs()[atIndex]
        switch input {
        case .DrillRigCost:
            if let number = NSNumberFormatter().formatterDecimalWith2Fractions().numberFromString(stringValue) {
                drillRigCost = .DrillRigCost(number.doubleValue)
                return true
            }
        case .RegrindCost:
            if let number = NSNumberFormatter().formatterDecimalWith2Fractions().numberFromString(stringValue) {
                regrindCost = .RegrindCost(number.doubleValue)
                return true
            }
        case .BitChangeTime:
            if let number = NSNumberFormatter().formatterDecimalWith2Fractions().numberFromString(stringValue) {
                bitChangeTime = .BitChangeTime(number.doubleValue)
                return true
            }
        case .DrilledMeters:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                drilledMeters = .DrilledMeters(number.unsignedLongValue)
                return true
            }
        case .BitPrice:
            if let number = NSNumberFormatter().formatterDecimalWith2Fractions().numberFromString(stringValue) {
                bitPrice = .BitPrice(number.doubleValue)
                return true
            }
        case .ServiceLife:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                serviceLife = .ServiceLife(number.unsignedLongValue)
                return true
            }
        case .NoOfBitRegrinds:
            if let number = NSNumberFormatter().formatterDecimalWith2Fractions().numberFromString(stringValue) {
                noOfBitRegrinds = .NoOfBitRegrinds(number.doubleValue)
                return true
            }
        }
        return false
    }
    
    override func getInputAsString(atIndex :Int) -> String? {
        let input = allInputs()[atIndex]
        switch input {
        case .DrillRigCost:
            return NSNumberFormatter().formatterDecimalWith2Fractions().stringFromNumber(drillRigCost.value as! Double)
        case .RegrindCost:
            return NSNumberFormatter().formatterDecimalWith2Fractions().stringFromNumber(regrindCost.value as! Double)
        case .BitChangeTime:
            return NSNumberFormatter().formatterDecimalWith2Fractions().stringFromNumber(bitChangeTime.value as! Double)
        case .DrilledMeters:
            return NSNumberFormatter().stringFromNumber(drilledMeters.value as! UInt)
        case .BitPrice:
            return NSNumberFormatter().formatterDecimalWith2Fractions().stringFromNumber(bitPrice.value as! Double)
        case .ServiceLife:
            return NSNumberFormatter().stringFromNumber(serviceLife.value as! UInt)
        case .NoOfBitRegrinds:
            return NSNumberFormatter().formatterDecimalWith2Fractions().stringFromNumber(noOfBitRegrinds.value as! Double)
        }
    }
    
    override func getInputAbbreviation(atIndex :Int) -> InputAbbreviation? {
        let input = allInputs()[atIndex]
        switch input {
        case .DrillRigCost:
            return InputAbbreviation.USDHour
        case .RegrindCost:
            return InputAbbreviation.USD
        case .BitChangeTime:
            return InputAbbreviation.Minutes
        case .DrilledMeters:
            return InputAbbreviation.Meter
        case .BitPrice:
            return InputAbbreviation.USD
        case .ServiceLife:
            return InputAbbreviation.Meter
        case .NoOfBitRegrinds:
            return nil
        }
    }
    
    
    override func changeInput(atIndex :Int, change :ChangeInput) -> String {
        let input = allInputs()[atIndex]
        if change != ChangeInput.Load {
            let v = (change == ChangeInput.Increase ? 1 : -1)
            switch input {
            case .DrillRigCost:
                let value = input.value as! Double + Double(v)
                if value >= 0 {
                    drillRigCost = .DrillRigCost(value)
                }
            case .RegrindCost:
                let value = input.value as! Double + Double(v)
                if value >= 0 {
                    regrindCost = .RegrindCost(value)
                }
            case .BitChangeTime:
                let value = input.value as! Double + Double(v)
                if value >= 0 {
                    bitChangeTime = .BitChangeTime(value)
                }
            case .DrilledMeters:
                let value = Int(input.value as! UInt) + v
                if value >= 0 {
                    drilledMeters = .DrilledMeters(UInt(value))
                }
            case .BitPrice:
                let value = input.value as! Double + Double(v)
                if value >= 0 {
                    bitPrice = .BitPrice(value)
                }
            case .ServiceLife:
                let value = Int(input.value as! UInt) + v
                if value >= 0 {
                    serviceLife = .ServiceLife(UInt(value))
                }
            case .NoOfBitRegrinds:
                let value = input.value as! Double + Double(v)
                if value >= 0 {
                    noOfBitRegrinds = .NoOfBitRegrinds(value)
                }
            }
        }
        return getInputAsString(atIndex)!
    }
}
