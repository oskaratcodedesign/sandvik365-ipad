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
    //case CostPerDayNotRunning(UInt)
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
        /*case CostPerDayNotRunning:
            return NSLocalizedString("Cost per day for rockdrill not running", comment: "")*/
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
        /*case CostPerDayNotRunning(let value):
            return value*/
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

class ROIRockDrillInput: ROIInput {
    var typeOfOre: ROIRockDrillInputValue = .TypeOfOre(OreType.Gold)
    var commodityPrice: ROIRockDrillInputValue = .CommodityPrice(800)
    var oreConcentration: ROIRockDrillInputValue = .OreConcentration(10)
    //var costPerDayNotRunning: ROIRockDrillInputValue = .CostPerDayNotRunning(70000)
    var utilizationRate: ROIRockDrillInputValue = .UtilizationRate(25)
    var oreGravity: ROIRockDrillInputValue = .OreGravity(1808)
    var holesInAFace: ROIRockDrillInputValue = .HolesInAFace(64)
    var drillFaceWidth: ROIRockDrillInputValue = .DrillFaceWidth(4.5)
    var drillFaceHeight: ROIRockDrillInputValue = .DrillFaceHeight(4.5)
    var feedLenght: ROIRockDrillInputValue = .FeedLenght(4.8)
    var numberOfBooms: ROIRockDrillInputValue = .NumberOfBooms(2)
    
    var product: ROIRockDrillProduct = .None
    let standardMeterHour: Double = 112.5 / 2
    
    
    private func allInputs() -> [ROIRockDrillInputValue] {
        return [typeOfOre, commodityPrice, oreConcentration, utilizationRate, oreGravity, holesInAFace, drillFaceWidth, drillFaceHeight, feedLenght, numberOfBooms]
    }
    

    private func cumbicMeterBlast() -> Double {
        if let dw = drillFaceWidth.value as? Double, dh = drillFaceHeight.value as? Double, fl = feedLenght.value as? Double {
            return dw * dh * fl
        }
        return 0
    }
    
    private func meterDrilledBlast() -> Double {
        if let hf = holesInAFace.value as? Double, fl = feedLenght.value as? Double {
            return hf * fl
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
    
    private func metersDrilledYearlyBefore() -> Double {
        if let nb = numberOfBooms.value as? UInt {
            return standardMeterHour * percussionHoursDay() * 365 * Double(nb)
        }
        return 0
    }
    
    private func tonnageOutputBefore() -> Double {
        return (metersDrilledYearlyBefore() / meterDrilledBlast()) * tonnesBlast()
    }
    
    private func metersDrilledYearlyAfter() -> Double {
        if product != .None {
            return metersDrilledYearlyBefore() * (1+product.rawValue)
        }
        return metersDrilledYearlyBefore()
    }
    
    private func tonnageOutputAfter() -> Double {
        return (metersDrilledYearlyAfter() / meterDrilledBlast()) * tonnesBlast()

    }
    
    override func total() -> Double {
        switch typeOfOre.value as! OreType  {
        case .Gold:
            if let oc = oreConcentration.value as? UInt, cp = commodityPrice.value as? UInt {
                return ((tonnageOutputAfter() - tonnageOutputBefore()) * Double(oc)) * OreType.Gold.rawValue * Double(cp)
            }
        case .Copper:
            if let oc = oreConcentration.value as? UInt, cp = commodityPrice.value as? UInt {
                return ((tonnageOutputAfter() - tonnageOutputBefore()) * OreType.Copper.rawValue * (Double(oc)) / 100) *  Double(cp)
            }
        }
        return 0
    }
    
    override func maxTotal() -> Double {
        return metersDrilledYearlyAfter()
    }
    
    override func originalTotal() -> [Int] {
        preconditionFailure("This method must be overridden")
    }
    
    override func calculatedTotal() -> [Int] {
        preconditionFailure("This method must be overridden")
    }

    override func allTitles() -> [String] {
        var allTitles = [String]()
        let all = allInputs()
        for v in all {
            allTitles.append(v.title)
        }
        return allTitles
    }
    
    override func changeInput(atIndex :Int, change : ChangeInput) -> NSAttributedString {
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
            let typeString: String = typeOfOre.value as! OreType == .Gold ? "Gold" : "Copper"
            let attrString = NSMutableAttributedString(string: typeString, attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            return attrString
        case .CommodityPrice:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    commodityPrice = .CommodityPrice(UInt(value))
                }
            }
            let valueType: String = "$"
            let attrString = NSMutableAttributedString(string: valueType + String(commodityPrice.value as! UInt), attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "AktivGroteskCorp-Light", size: 1.0)!, range: NSRange(location: 0,length: valueType.characters.count))
            return attrString
        case .OreConcentration:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    oreConcentration = .OreConcentration(UInt(value))
                }
            }
            let valueType: String = "g"
            let attrString = NSMutableAttributedString(string: String(oreConcentration.value as! UInt) + valueType, attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "AktivGroteskCorp-Light", size: 1.0)!, range: NSRange(location: attrString.length-valueType.characters.count,length: valueType.characters.count))
            return attrString
        /*case CostPerDayNotRunning:
        return NSLocalizedString("Cost per day for rockdrill not running", comment: "")*/
        case .UtilizationRate:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    utilizationRate = .UtilizationRate(UInt(value))
                }
            }
            let valueType: String = "%"
            let attrString = NSMutableAttributedString(string: String(utilizationRate.value as! UInt) + valueType, attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "AktivGroteskCorp-Light", size: 1.0)!, range: NSRange(location: attrString.length-valueType.characters.count,length: valueType.characters.count))
            return attrString
        case .OreGravity:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    oreGravity = .OreGravity(UInt(value))
                }
            }
            let valueType: String = "kg"
            let attrString = NSMutableAttributedString(string: String(oreGravity.value as! UInt) + valueType, attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "AktivGroteskCorp-Light", size: 1.0)!, range: NSRange(location: attrString.length-valueType.characters.count,length: valueType.characters.count))
            return attrString
        case .HolesInAFace:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    holesInAFace = .HolesInAFace(UInt(value))
                }
            }
            let attrString = NSMutableAttributedString(string: String(holesInAFace.value as! UInt), attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            return attrString
        case .DrillFaceWidth:
            if change != ChangeInput.Load {
                let value = input.value as! Double + (change == ChangeInput.Increase ? 0.10 : -0.10)
                if value >= 0 {
                    drillFaceWidth = .DrillFaceWidth(value)
                }
            }
            let attrString = NSMutableAttributedString(string: String(format:"%.2f", drillFaceWidth.value as! Double), attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            return attrString
        case .DrillFaceHeight:
            if change != ChangeInput.Load {
                let value = input.value as! Double + (change == ChangeInput.Increase ? 0.10 : -0.10)
                if value >= 0 {
                    drillFaceHeight = .DrillFaceHeight(value)
                }
            }
            let attrString = NSMutableAttributedString(string: String(format:"%.2f", drillFaceHeight.value as! Double), attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            return attrString
        case .FeedLenght:
            if change != ChangeInput.Load {
                let value = input.value as! Double + (change == ChangeInput.Increase ? 0.10 : -0.10)
                if value >= 0 {
                    feedLenght = .FeedLenght(value)
                }
            }
            let attrString = NSMutableAttributedString(string: String(format:"%.2f", feedLenght.value as! Double), attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            return attrString
        case .NumberOfBooms:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    numberOfBooms = .NumberOfBooms(UInt(value))
                }
            }
            let attrString = NSMutableAttributedString(string: String(numberOfBooms.value as! UInt), attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            return attrString
        }

    }
}