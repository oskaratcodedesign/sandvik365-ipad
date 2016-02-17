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
    case RD520 = 0.3
    case RD525 = 0.5
    case None = 0
}

enum OreType: Double {
    case Gold = 0.0321507466
    case Copper = 2679.23
}

enum ROIRockDrillInputValue {
    case TypeOfOre(OreType)
    case CommodityPrice(UInt)
    case OreConcentration(UInt)
    case UtilizationRate(UInt)
    case OreGravity(UInt)
    case HolesInAFace(UInt)
    case DrillFaceWidth(Double)
    case DrillFaceHeight(Double)
    case FeedLenght(Double)
    case NumberOfBooms(UInt)
    
    var title :String {
        switch self {
        case TypeOfOre:
            return NSLocalizedString("Type of ore", comment: "")
        case CommodityPrice:
            return NSLocalizedString("Commodity price", comment: "")
        case OreConcentration:
            return NSLocalizedString("Ore concentration", comment: "")
        case UtilizationRate:
            return NSLocalizedString("Utilization rate", comment: "")
        case OreGravity:
            return NSLocalizedString("Ore gravity", comment: "")
        case HolesInAFace:
            return NSLocalizedString("Holes in a face", comment: "")
        case DrillFaceWidth:
            return NSLocalizedString("Drill face width", comment: "")
        case DrillFaceHeight:
            return NSLocalizedString("Drill face height", comment: "")
        case FeedLenght:
            return NSLocalizedString("Feed lenght", comment: "")
        case NumberOfBooms:
            return NSLocalizedString("Number of booms", comment: "")
        }
    }
    
    var value: Any {
        switch self {
        case TypeOfOre(let value):
            return value
        case CommodityPrice(let value):
            return value
        case OreConcentration(let value):
            return value
        case UtilizationRate(let value):
            return value
        case OreGravity(let value):
            return value
        case HolesInAFace(let value):
            return value
        case DrillFaceWidth(let value):
            return value
        case DrillFaceHeight(let value):
            return value
        case FeedLenght(let value):
            return value
        case NumberOfBooms(let value):
            return value
        }
    }
}

class ROIRockDrillInput: ROICalculatorInput {
    var typeOfOre: ROIRockDrillInputValue = .TypeOfOre(OreType.Gold)
    var commodityPrice: ROIRockDrillInputValue = .CommodityPrice(800)
    var oreConcentration: ROIRockDrillInputValue = .OreConcentration(10)
    var utilizationRate: ROIRockDrillInputValue = .UtilizationRate(25)
    var oreGravity: ROIRockDrillInputValue = .OreGravity(1808)
    var holesInAFace: ROIRockDrillInputValue = .HolesInAFace(64)
    var drillFaceWidth: ROIRockDrillInputValue = .DrillFaceWidth(4.5)
    var drillFaceHeight: ROIRockDrillInputValue = .DrillFaceHeight(4.5)
    var feedLenght: ROIRockDrillInputValue = .FeedLenght(4.8)
    var numberOfBooms: ROIRockDrillInputValue = .NumberOfBooms(2)
    
    var product: ROIRockDrillProduct = .None
    let standardMeterHour: Double = 112.5 / 2
    let months: Int = 12
    
    private func allInputs() -> [ROIRockDrillInputValue] {
        return [typeOfOre, commodityPrice, oreConcentration, utilizationRate, oreGravity, holesInAFace, drillFaceWidth, drillFaceHeight, feedLenght, numberOfBooms]
    }
    
    override func allTitles() -> [String] {
        return allInputs().flatMap({ $0.title })
    }

    private func cumbicMeterBlast() -> Double {
        if let dw = drillFaceWidth.value as? Double, dh = drillFaceHeight.value as? Double, fl = feedLenght.value as? Double {
            return dw * dh * fl
        }
        return 0
    }
    
    private func meterDrilledBlast() -> Double {
        if let hf = holesInAFace.value as? UInt, fl = feedLenght.value as? Double {
            return Double(hf) * fl
        }
        return 0
    }
    
    private func tonnesBlast() -> Double {
        if let og = oreGravity.value as? UInt {
            return cumbicMeterBlast() * Double(og) / 1000
        }
        return 0
    }
    
    private func productiveHoursDay() -> Double {
        if let ur = utilizationRate.value as? UInt {
            return 24 * Double(ur) / 100
        }
        return 0
    }
    
    private func percussionHoursDay() -> Double {
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
        if product != .None {
            return metersDrilledYearlyBefore() * (1+product.rawValue)
        }
        return metersDrilledYearlyBefore()
    }
    
    func tonnageOutputAfter() -> Double {
        return (metersDrilledYearlyAfter() / meterDrilledBlast()) * tonnesBlast()

    }
    
    private func shanks() -> Double {
        return (metersDrilledYearlyAfter() / (1200 * ( 1 + 0.4)))-(metersDrilledYearlyAfter()/1200)
    }
    
    private func bits() -> Double {
        return (metersDrilledYearlyAfter() / (225 * ( 1 + 0.17)))-(metersDrilledYearlyAfter()/225)
    }
    
    func shanksAndBitsSavings() -> Double {
        return (shanks() * 167 + 62 * bits()) * -1
    }
    
    override func total() -> Int? {
        switch typeOfOre.value as! OreType  {
        case .Gold:
            if let oc = oreConcentration.value as? UInt, cp = commodityPrice.value as? UInt {
                let res = (((tonnageOutputAfter() - tonnageOutputBefore()) * Double(oc)) * OreType.Gold.rawValue * Double(cp)) + shanksAndBitsSavings()
                if res > Double(Int.max) {
                    return Int.max
                }
                else {
                    return Int(res)
                }
            }
        case .Copper:
            if let oc = oreConcentration.value as? UInt, cp = commodityPrice.value as? UInt {
                let res = (((tonnageOutputAfter() - tonnageOutputBefore()) * OreType.Copper.rawValue * (Double(oc)) / 100) *  Double(cp)) + shanksAndBitsSavings()
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
        product = .RD525
        let result = tonnageOutputAfter()
        product = currentProduct
        return result
    }
    
    override func originalTotal() -> [Int] {
        let t = Int(tonnageOutputBefore())
        let totals = [Int](count: months, repeatedValue: t)
        return totals
    }
    
    override func calculatedTotal() -> [Int] {
        let t = Int(tonnageOutputAfter())
        let totals = [Int](count: months, repeatedValue: t)
        return totals
    }
    
    override func setInput(atIndex :Int, stringValue :String) -> Bool {
        let input = allInputs()[atIndex]
        switch input {
        case .TypeOfOre:
            return false
        case .CommodityPrice:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                commodityPrice = .CommodityPrice(number.unsignedLongValue)
                return true
            }
        case .OreConcentration:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                oreConcentration = .OreConcentration(number.unsignedLongValue)
                return true
            }
        case .UtilizationRate:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                utilizationRate = .UtilizationRate(number.unsignedLongValue)
                return true
            }
        case .OreGravity:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                oreGravity = .OreGravity(number.unsignedLongValue)
                return true
            }
        case .HolesInAFace:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                holesInAFace = .HolesInAFace(number.unsignedLongValue)
                return true
            }
        case .DrillFaceWidth:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                drillFaceWidth = .DrillFaceWidth(number.doubleValue)
                return true
            }
        case .DrillFaceHeight:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                drillFaceHeight = .DrillFaceHeight(number.doubleValue)
                return true
            }
        case .FeedLenght:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                feedLenght = .FeedLenght(number.doubleValue)
                return true
            }
        case .NumberOfBooms:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                numberOfBooms = .NumberOfBooms(number.unsignedLongValue)
                return true
            }
        }
        
        return false
    }
    
    override func getInputAsString(atIndex :Int) -> String? {
        let input = allInputs()[atIndex]
        switch input {
        case .TypeOfOre:
            return nil
        case .CommodityPrice:
            return String(commodityPrice.value as! UInt)
        case .OreConcentration:
            return String(oreConcentration.value as! UInt)
        case .UtilizationRate:
            return String(utilizationRate.value as! UInt)
        case .OreGravity:
            return String(oreGravity.value as! UInt)
        case .HolesInAFace:
            return String(holesInAFace.value as! UInt)
        case .DrillFaceWidth:
            return String(format:"%.2f", drillFaceWidth.value as! Double)
        case .DrillFaceHeight:
            return String(format:"%.2f", drillFaceHeight.value as! Double)
        case .FeedLenght:
            return String(format:"%.2f", feedLenght.value as! Double)
        case .NumberOfBooms:
            return String(numberOfBooms.value as! UInt)
        }
    }
    
    override func getInputAbbreviation(atIndex :Int) -> InputAbbreviation? {
        let input = allInputs()[atIndex]
        switch input {
        case .TypeOfOre:
            return nil
        case .CommodityPrice:
            return InputAbbreviation.USD
        case .OreConcentration:
            return InputAbbreviation.Gram
        case .UtilizationRate:
            return InputAbbreviation.Percent
        case .OreGravity:
            return InputAbbreviation.Kilo
        case .HolesInAFace:
            return nil
        case .DrillFaceWidth:
            return InputAbbreviation.Meter
        case .DrillFaceHeight:
            return InputAbbreviation.Meter
        case .FeedLenght:
            return InputAbbreviation.Meter
        case .NumberOfBooms:
            return nil
        }
    }
    
    override func changeInput(atIndex :Int, change : ChangeInput) -> String {
        let input = allInputs()[atIndex]
        switch input {
        case .TypeOfOre:
            let value = typeOfOre.value as! OreType
            if change != ChangeInput.Load {
                if value == .Gold {
                    typeOfOre = .TypeOfOre(.Copper)
                }
                else {
                    typeOfOre = .TypeOfOre(.Gold)
                }
            }
            return typeOfOre.value as! OreType == .Gold ? "Gold" : "Copper"
        case .CommodityPrice:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    commodityPrice = .CommodityPrice(UInt(value))
                }
            }
        case .OreConcentration:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    oreConcentration = .OreConcentration(UInt(value))
                }
            }
        case .UtilizationRate:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    utilizationRate = .UtilizationRate(UInt(value))
                }
            }
        case .OreGravity:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    oreGravity = .OreGravity(UInt(value))
                }
            }
        case .HolesInAFace:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    holesInAFace = .HolesInAFace(UInt(value))
                }
            }
        case .DrillFaceWidth:
            if change != ChangeInput.Load {
                let value = input.value as! Double + (change == ChangeInput.Increase ? 0.10 : -0.10)
                if value >= 0 {
                    drillFaceWidth = .DrillFaceWidth(value)
                }
            }
        case .DrillFaceHeight:
            if change != ChangeInput.Load {
                let value = input.value as! Double + (change == ChangeInput.Increase ? 0.10 : -0.10)
                if value >= 0 {
                    drillFaceHeight = .DrillFaceHeight(value)
                }
            }
        case .FeedLenght:
            if change != ChangeInput.Load {
                let value = input.value as! Double + (change == ChangeInput.Increase ? 0.10 : -0.10)
                if value >= 0 {
                    feedLenght = .FeedLenght(value)
                }
            }
        case .NumberOfBooms:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    numberOfBooms = .NumberOfBooms(UInt(value))
                }
            }
        }
        return getInputAsString(atIndex)!
    }
    
    override func graphScale() -> CGFloat {
        return 0.5
    }
}