//
//  ROIRockDrillInput.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 18/09/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation

enum ROIRockDrillProduct {
    case RD520
    case RD525
    case None
}

enum OreType {
    case Gold
    case Copper
}

enum ROIRockDrillInputValue {
    case TypeOfOre(OreType)
    case CommodityPrice(UInt)
    case OreConcentration(UInt)
    case CostPerDayNotRunning(UInt)
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
        case CostPerDayNotRunning:
            return NSLocalizedString("Cost per day for rockdrill not running", comment: "")
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
        case CostPerDayNotRunning(let value):
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

class ROIRockDrillInput: ROIInput {
    var typeOfOre: ROIRockDrillInputValue = .TypeOfOre(OreType.Gold)
    var commodityPrice: ROIRockDrillInputValue = .CommodityPrice(800)
    var oreConcentration: ROIRockDrillInputValue = .OreConcentration(10)
    var costPerDayNotRunning: ROIRockDrillInputValue = .CostPerDayNotRunning(70000)
    var utilizationRate: ROIRockDrillInputValue = .UtilizationRate(25)
    var processingCost: ROIRockDrillInputValue = .OreGravity(1808)
    var holesInAFace: ROIRockDrillInputValue = .HolesInAFace(64)
    var drillFaceWidth: ROIRockDrillInputValue = .DrillFaceWidth(4.5)
    var drillFaceHeight: ROIRockDrillInputValue = .DrillFaceHeight(4.5)
    var feedLenght: ROIRockDrillInputValue = .FeedLenght(4.8)
    var numberOfBooms: ROIRockDrillInputValue = .NumberOfBooms(2)
    
    var product: ROIRockDrillProduct = .None

    func totals() -> Double {
        return 0
    }
}