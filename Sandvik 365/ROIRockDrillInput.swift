//
//  ROIRockDrillInput.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 18/09/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation
import UIKit

enum ROIRockDrillProduct: Double {
    case rd520 = 0.3
    case rd525 = 0.5
    case none = 0
}

enum OreType: Double {
    case gold = 0.0321507466
    case copper = 2679.23
}

enum ROIRockDrillInputValue {
    case typeOfOre(OreType)
    case commodityPrice(UInt)
    case oreConcentration(UInt)
    case utilizationRate(UInt)
    case oreGravity(UInt)
    case holesInAFace(UInt)
    case drillFaceWidth(Double)
    case drillFaceHeight(Double)
    case feedLenght(Double)
    case numberOfBooms(UInt)
    
    var title :String {
        switch self {
        case .typeOfOre:
            return NSLocalizedString("Type of ore", comment: "")
        case .commodityPrice:
            return NSLocalizedString("Commodity price", comment: "")
        case .oreConcentration:
            return NSLocalizedString("Ore concentration", comment: "")
        case .utilizationRate:
            return NSLocalizedString("Utilization rate", comment: "")
        case .oreGravity:
            return NSLocalizedString("Ore gravity", comment: "")
        case .holesInAFace:
            return NSLocalizedString("Holes in a face", comment: "")
        case .drillFaceWidth:
            return NSLocalizedString("Drill face width", comment: "")
        case .drillFaceHeight:
            return NSLocalizedString("Drill face height", comment: "")
        case .feedLenght:
            return NSLocalizedString("Feed lenght", comment: "")
        case .numberOfBooms:
            return NSLocalizedString("Number of booms", comment: "")
        }
    }
    
    var value: Any {
        switch self {
        case .typeOfOre(let value):
            return value
        case .commodityPrice(let value):
            return value
        case .oreConcentration(let value):
            return value
        case .utilizationRate(let value):
            return value
        case .oreGravity(let value):
            return value
        case .holesInAFace(let value):
            return value
        case .drillFaceWidth(let value):
            return value
        case .drillFaceHeight(let value):
            return value
        case .feedLenght(let value):
            return value
        case .numberOfBooms(let value):
            return value
        }
    }
}

class ROIRockDrillInput: ROICalculatorInput {
    var typeOfOre: ROIRockDrillInputValue = .typeOfOre(OreType.gold)
    var commodityPrice: ROIRockDrillInputValue = .commodityPrice(800)
    var oreConcentration: ROIRockDrillInputValue = .oreConcentration(10)
    var utilizationRate: ROIRockDrillInputValue = .utilizationRate(25)
    var oreGravity: ROIRockDrillInputValue = .oreGravity(1808)
    var holesInAFace: ROIRockDrillInputValue = .holesInAFace(64)
    var drillFaceWidth: ROIRockDrillInputValue = .drillFaceWidth(4.5)
    var drillFaceHeight: ROIRockDrillInputValue = .drillFaceHeight(4.5)
    var feedLenght: ROIRockDrillInputValue = .feedLenght(4.8)
    var numberOfBooms: ROIRockDrillInputValue = .numberOfBooms(2)
    
    var product: ROIRockDrillProduct = .none
    let standardMeterHour: Double = 112.5 / 2
    let months: Int = 12
    
    fileprivate func allInputs() -> [ROIRockDrillInputValue] {
        return [typeOfOre, commodityPrice, oreConcentration, utilizationRate, oreGravity, holesInAFace, drillFaceWidth, drillFaceHeight, feedLenght, numberOfBooms]
    }
    
    override func allTitles() -> [String] {
        return allInputs().flatMap({ $0.title })
    }

    fileprivate func cumbicMeterBlast() -> Double {
        if let dw = drillFaceWidth.value as? Double, let dh = drillFaceHeight.value as? Double, let fl = feedLenght.value as? Double {
            return dw * dh * fl
        }
        return 0
    }
    
    fileprivate func meterDrilledBlast() -> Double {
        if let hf = holesInAFace.value as? UInt, let fl = feedLenght.value as? Double {
            return Double(hf) * fl
        }
        return 0
    }
    
    fileprivate func tonnesBlast() -> Double {
        if let og = oreGravity.value as? UInt {
            return cumbicMeterBlast() * Double(og) / 1000
        }
        return 0
    }
    
    fileprivate func productiveHoursDay() -> Double {
        if let ur = utilizationRate.value as? UInt {
            return 24 * Double(ur) / 100
        }
        return 0
    }
    
    fileprivate func percussionHoursDay() -> Double {
        return productiveHoursDay() * 0.75
    }
    
    func metersDrilledYearlyBefore() -> Double {
        if let nb = numberOfBooms.value as? UInt {
            return standardMeterHour * percussionHoursDay() * 365 * Double(nb)
        }
        return 0
    }
    
    func tonnageOutputBefore() -> Double {
        return (metersDrilledYearlyBefore() / meterDrilledBlast()) * tonnesBlast()
    }
    
    func metersDrilledYearlyAfter() -> Double {
        if product != .none {
            return metersDrilledYearlyBefore() * (1+product.rawValue)
        }
        return metersDrilledYearlyBefore()
    }
    
    func tonnageOutputAfter() -> Double {
        return (metersDrilledYearlyAfter() / meterDrilledBlast()) * tonnesBlast()

    }
    
    fileprivate func shanks() -> Double {
        return (metersDrilledYearlyAfter() / (1200 * ( 1 + 0.4)))-(metersDrilledYearlyAfter()/1200)
    }
    
    fileprivate func bits() -> Double {
        return (metersDrilledYearlyAfter() / (225 * ( 1 + 0.17)))-(metersDrilledYearlyAfter()/225)
    }
    
    func shanksAndBitsSavings() -> Double {
        return (shanks() * 167 + 62 * bits()) * -1
    }
    
    override func total() -> Int? {
        switch typeOfOre.value as! OreType  {
        case .gold:
            if let oc = oreConcentration.value as? UInt, let cp = commodityPrice.value as? UInt {
                let res = (((tonnageOutputAfter() - tonnageOutputBefore()) * Double(oc)) * OreType.gold.rawValue * Double(cp)) + shanksAndBitsSavings()
                if res > Double(Int.max) {
                    return Int.max
                }
                else {
                    return Int(res)
                }
            }
        case .copper:
            if let oc = oreConcentration.value as? UInt, let cp = commodityPrice.value as? UInt {
                let res = (((tonnageOutputAfter() - tonnageOutputBefore()) * OreType.copper.rawValue * (Double(oc)) / 100) *  Double(cp)) + shanksAndBitsSavings()
                if res > Double(Int.max) {
                    return Int.max
                }
                else {
                    return Int(res)
                }
            }
        }
        return 0
    }
    
    override func maxTotal() -> Double {
        let currentProduct = product
        product = .rd525
        let result = tonnageOutputAfter()
        product = currentProduct
        return result
    }
    
    override func originalTotal() -> [Int] {
        let t = Int(tonnageOutputBefore())
        let totals = [Int](repeating: t, count: months)
        return totals
    }
    
    override func calculatedTotal() -> [Int] {
        let t = Int(tonnageOutputAfter())
        let totals = [Int](repeating: t, count: months)
        return totals
    }
    
    override func setInput(_ atIndex :Int, stringValue :String) -> Bool {
        let input = allInputs()[atIndex]
        switch input {
        case .typeOfOre:
            return false
        case .commodityPrice:
            if let number = NumberFormatter().number(from: stringValue) {
                commodityPrice = .commodityPrice(number.uintValue)
                return true
            }
        case .oreConcentration:
            if let number = NumberFormatter().number(from: stringValue) {
                oreConcentration = .oreConcentration(number.uintValue)
                return true
            }
        case .utilizationRate:
            if let number = NumberFormatter().number(from: stringValue) {
                utilizationRate = .utilizationRate(number.uintValue)
                return true
            }
        case .oreGravity:
            if let number = NumberFormatter().number(from: stringValue) {
                oreGravity = .oreGravity(number.uintValue)
                return true
            }
        case .holesInAFace:
            if let number = NumberFormatter().number(from: stringValue) {
                holesInAFace = .holesInAFace(number.uintValue)
                return true
            }
        case .drillFaceWidth:
            if let number = NumberFormatter().number(from: stringValue) {
                drillFaceWidth = .drillFaceWidth(number.doubleValue)
                return true
            }
        case .drillFaceHeight:
            if let number = NumberFormatter().number(from: stringValue) {
                drillFaceHeight = .drillFaceHeight(number.doubleValue)
                return true
            }
        case .feedLenght:
            if let number = NumberFormatter().number(from: stringValue) {
                feedLenght = .feedLenght(number.doubleValue)
                return true
            }
        case .numberOfBooms:
            if let number = NumberFormatter().number(from: stringValue) {
                numberOfBooms = .numberOfBooms(number.uintValue)
                return true
            }
        }
        
        return false
    }
    
    override func getInputAsString(_ atIndex :Int) -> String? {
        let input = allInputs()[atIndex]
        switch input {
        case .typeOfOre:
            return nil
        case .commodityPrice:
            return String(commodityPrice.value as! UInt)
        case .oreConcentration:
            return String(oreConcentration.value as! UInt)
        case .utilizationRate:
            return String(utilizationRate.value as! UInt)
        case .oreGravity:
            return String(oreGravity.value as! UInt)
        case .holesInAFace:
            return String(holesInAFace.value as! UInt)
        case .drillFaceWidth:
            return String(format:"%.2f", drillFaceWidth.value as! Double)
        case .drillFaceHeight:
            return String(format:"%.2f", drillFaceHeight.value as! Double)
        case .feedLenght:
            return String(format:"%.2f", feedLenght.value as! Double)
        case .numberOfBooms:
            return String(numberOfBooms.value as! UInt)
        }
    }
    
    override func getInputAbbreviation(_ atIndex :Int) -> InputAbbreviation? {
        let input = allInputs()[atIndex]
        switch input {
        case .typeOfOre:
            return nil
        case .commodityPrice:
            return InputAbbreviation.USD
        case .oreConcentration:
            return InputAbbreviation.Gram
        case .utilizationRate:
            return InputAbbreviation.Percent
        case .oreGravity:
            return InputAbbreviation.Kilo
        case .holesInAFace:
            return nil
        case .drillFaceWidth:
            return InputAbbreviation.Meter
        case .drillFaceHeight:
            return InputAbbreviation.Meter
        case .feedLenght:
            return InputAbbreviation.Meter
        case .numberOfBooms:
            return nil
        }
    }
    
    override func changeInput(_ atIndex :Int, change : ChangeInput) -> String {
        let input = allInputs()[atIndex]
        switch input {
        case .typeOfOre:
            let value = typeOfOre.value as! OreType
            if change != ChangeInput.load {
                if value == .gold {
                    typeOfOre = .typeOfOre(.copper)
                }
                else {
                    typeOfOre = .typeOfOre(.gold)
                }
            }
            return typeOfOre.value as! OreType == .gold ? "Gold" : "Copper"
        case .commodityPrice:
            if change != ChangeInput.load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.increase ? 1 : -1)
                if value >= 0 {
                    commodityPrice = .commodityPrice(UInt(value))
                }
            }
        case .oreConcentration:
            if change != ChangeInput.load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.increase ? 1 : -1)
                if value >= 0 {
                    oreConcentration = .oreConcentration(UInt(value))
                }
            }
        case .utilizationRate:
            if change != ChangeInput.load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.increase ? 1 : -1)
                if value >= 0 {
                    utilizationRate = .utilizationRate(UInt(value))
                }
            }
        case .oreGravity:
            if change != ChangeInput.load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.increase ? 1 : -1)
                if value >= 0 {
                    oreGravity = .oreGravity(UInt(value))
                }
            }
        case .holesInAFace:
            if change != ChangeInput.load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.increase ? 1 : -1)
                if value >= 0 {
                    holesInAFace = .holesInAFace(UInt(value))
                }
            }
        case .drillFaceWidth:
            if change != ChangeInput.load {
                let value = input.value as! Double + (change == ChangeInput.increase ? 0.10 : -0.10)
                if value >= 0 {
                    drillFaceWidth = .drillFaceWidth(value)
                }
            }
        case .drillFaceHeight:
            if change != ChangeInput.load {
                let value = input.value as! Double + (change == ChangeInput.increase ? 0.10 : -0.10)
                if value >= 0 {
                    drillFaceHeight = .drillFaceHeight(value)
                }
            }
        case .feedLenght:
            if change != ChangeInput.load {
                let value = input.value as! Double + (change == ChangeInput.increase ? 0.10 : -0.10)
                if value >= 0 {
                    feedLenght = .feedLenght(value)
                }
            }
        case .numberOfBooms:
            if change != ChangeInput.load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.increase ? 1 : -1)
                if value >= 0 {
                    numberOfBooms = .numberOfBooms(UInt(value))
                }
            }
        }
        return getInputAsString(atIndex)!
    }
    
    override func graphScale() -> CGFloat {
        return 0.5
    }
}
