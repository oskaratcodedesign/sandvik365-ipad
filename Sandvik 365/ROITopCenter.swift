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
    case savedBitCost
    case savedGrindingCost
    case savedValueCost
}

enum ROITopCenterInputValue {
    case drillRigCost(Double)
    case regrindCost(Double)
    case bitChangeTime(Double)
    case drilledMeters(UInt)
    case bitPrice(Double)
    case serviceLife(UInt)
    case noOfBitRegrinds(Double)
    
    var title :String {
        switch self {
        case .drillRigCost:
            return NSLocalizedString("Drill rig cost", comment: "")
        case .regrindCost:
            return NSLocalizedString("Regrind cost", comment: "")
        case .bitChangeTime:
            return NSLocalizedString("Time to change bit", comment: "")
        case .drilledMeters:
            return NSLocalizedString("Drill meters per year", comment: "")
        case .bitPrice:
            return NSLocalizedString("Bit price for current bit", comment: "")
        case .serviceLife:
            return NSLocalizedString("Bit service life for current bit", comment: "")
        case .noOfBitRegrinds:
            return NSLocalizedString("Number of regrinds/current bit", comment: "")
        }
    }
    
    var description :String {
        switch self {
        case .drillRigCost, .regrindCost, .bitPrice, .serviceLife, .noOfBitRegrinds:
            return ""
        case .bitChangeTime:
            return NSLocalizedString("State the time required to change each bit. I.e. total time divided by two if two bits are changed.", comment: "")
        case .drilledMeters:
            return NSLocalizedString("For all drill rigs using this bit.", comment: "")
        }
    }
    
    var value: Any {
        switch self {
        case .drillRigCost(let value):
            return value
        case .regrindCost(let value):
            return value
        case .bitChangeTime(let value):
            return value
        case .drilledMeters(let value):
            return value
        case .bitPrice(let value):
            return value
        case .serviceLife(let value):
            return value
        case .noOfBitRegrinds(let value):
            return value
        }
    }
}

class ROITopCenterInput: ROICalculatorInput {
    var drillRigCost: ROITopCenterInputValue = .drillRigCost(350)
    var regrindCost: ROITopCenterInputValue = .regrindCost(4.0)
    var bitChangeTime: ROITopCenterInputValue = .bitChangeTime(3.0)
    var drilledMeters: ROITopCenterInputValue = .drilledMeters(500000)
    var bitPrice: ROITopCenterInputValue = .bitPrice(50)
    var serviceLife: ROITopCenterInputValue = .serviceLife(200)
    var noOfBitRegrinds: ROITopCenterInputValue = .noOfBitRegrinds(3.0)
    
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
        if let dm = drilledMeters.value as? UInt, let sl = serviceLife.value as? UInt,
        let bp = bitPrice.value as? Double  {
            let v1 = Double(dm) / Double(sl) * bp
            let v2 = 1.2 / 1.5 * Double(dm) / Double(sl) * bp
            return v1 - v2
        }
        return 0
    }
    
    func savedGrindingCost() -> Double {
        if let dm = drilledMeters.value as? UInt, let rc = regrindCost.value as? Double, let sl = serviceLife.value as? UInt, let nr = noOfBitRegrinds.value as? Double  {
            return rc / 3 * Double(dm) / Double(sl) * nr
        }
        return 0
    }
    
    func timeSavedCost() -> Double {
        if let bc = bitChangeTime.value as? Double, let dm = drilledMeters.value as? UInt, let sl = serviceLife.value as? UInt, let nr = noOfBitRegrinds.value as? Double  {
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
            case ROITopCenterCostType.savedBitCost:
                result += savedBitCost()
            case ROITopCenterCostType.savedGrindingCost:
                result += savedGrindingCost()
            case ROITopCenterCostType.savedValueCost:
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
    
    override func setInput(_ atIndex :Int, stringValue :String) -> Bool {
        let input = allInputs()[atIndex]
        switch input {
        case .drillRigCost:
            if let number = NumberFormatter().formatterDecimalWith2Fractions().number(from: stringValue) {
                drillRigCost = .drillRigCost(number.doubleValue)
                return true
            }
        case .regrindCost:
            if let number = NumberFormatter().formatterDecimalWith2Fractions().number(from: stringValue) {
                regrindCost = .regrindCost(number.doubleValue)
                return true
            }
        case .bitChangeTime:
            if let number = NumberFormatter().formatterDecimalWith2Fractions().number(from: stringValue) {
                bitChangeTime = .bitChangeTime(number.doubleValue)
                return true
            }
        case .drilledMeters:
            if let number = NumberFormatter().formatterDecimalWith2Fractions().number(from: stringValue) {
                drilledMeters = .drilledMeters(number.uintValue)
                return true
            }
        case .bitPrice:
            if let number = NumberFormatter().formatterDecimalWith2Fractions().number(from: stringValue) {
                bitPrice = .bitPrice(number.doubleValue)
                return true
            }
        case .serviceLife:
            if let number = NumberFormatter().formatterDecimalWith2Fractions().number(from: stringValue) {
                serviceLife = .serviceLife(number.uintValue)
                return true
            }
        case .noOfBitRegrinds:
            if let number = NumberFormatter().formatterDecimalWith2Fractions().number(from: stringValue) {
                noOfBitRegrinds = .noOfBitRegrinds(number.doubleValue)
                return true
            }
        }
        return false
    }
    
    override func getInputAsString(_ atIndex :Int) -> String? {
        let input = allInputs()[atIndex]
        switch input {
        case .drillRigCost:
            return NumberFormatter().formatterDecimalWith2Fractions().string(from: drillRigCost.value as! Double)
        case .regrindCost:
            return NumberFormatter().formatterDecimalWith2Fractions().string(from: regrindCost.value as! Double)
        case .bitChangeTime:
            return NumberFormatter().formatterDecimalWith2Fractions().string(from: bitChangeTime.value as! Double)
        case .drilledMeters:
            return NumberFormatter().formatterDecimalWith2Fractions().string(from: drilledMeters.value as! UInt)
        case .bitPrice:
            return NumberFormatter().formatterDecimalWith2Fractions().string(from: bitPrice.value as! Double)
        case .serviceLife:
            return NumberFormatter().formatterDecimalWith2Fractions().string(from: serviceLife.value as! UInt)
        case .noOfBitRegrinds:
            return NumberFormatter().formatterDecimalWith2Fractions().string(from: noOfBitRegrinds.value as! Double)
        }
    }
    
    override func getInputAbbreviation(_ atIndex :Int) -> InputAbbreviation? {
        let input = allInputs()[atIndex]
        switch input {
        case .drillRigCost:
            return InputAbbreviation.USDHour
        case .regrindCost:
            return InputAbbreviation.USD
        case .bitChangeTime:
            return InputAbbreviation.Minutes
        case .drilledMeters:
            return InputAbbreviation.Meter
        case .bitPrice:
            return InputAbbreviation.USD
        case .serviceLife:
            return InputAbbreviation.Meter
        case .noOfBitRegrinds:
            return nil
        }
    }
    
    
    override func changeInput(_ atIndex :Int, change :ChangeInput) -> String {
        let input = allInputs()[atIndex]
        if change != ChangeInput.load {
            let v = (change == ChangeInput.increase ? 1 : -1)
            switch input {
            case .drillRigCost:
                let value = input.value as! Double + Double(v)
                if value >= 0 {
                    drillRigCost = .drillRigCost(value)
                }
            case .regrindCost:
                let value = input.value as! Double + Double(v)
                if value >= 0 {
                    regrindCost = .regrindCost(value)
                }
            case .bitChangeTime:
                let value = input.value as! Double + Double(v)
                if value >= 0 {
                    bitChangeTime = .bitChangeTime(value)
                }
            case .drilledMeters:
                let value = Int(input.value as! UInt) + v
                if value >= 0 {
                    drilledMeters = .drilledMeters(UInt(value))
                }
            case .bitPrice:
                let value = input.value as! Double + Double(v)
                if value >= 0 {
                    bitPrice = .bitPrice(value)
                }
            case .serviceLife:
                let value = Int(input.value as! UInt) + v
                if value >= 0 {
                    serviceLife = .serviceLife(UInt(value))
                }
            case .noOfBitRegrinds:
                let value = input.value as! Double + Double(v)
                if value >= 0 {
                    noOfBitRegrinds = .noOfBitRegrinds(value)
                }
            }
        }
        return getInputAsString(atIndex)!
    }
}
