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
    case RampUp = 200
    case ConditionInspection = 80
    case MaintenancePlanning = 8
    case Protective
    case None = 1
}

enum ROICrusherInputValue {
    case OreGrade(Double)
    case Capacity(UInt)
    case FinishedProduct(UInt)
    case RecoveryRate(UInt)
    case OrePrice(UInt)
    case ProcessingCost(UInt)

    var title :String {
        switch self {
        case OreGrade:
            return NSLocalizedString("Ore grade", comment: "")
        case Capacity:
            return NSLocalizedString("Crushing plant design capacity", comment: "")
        case FinishedProduct:
            return NSLocalizedString("Finished product from crushing plant", comment: "")
        case RecoveryRate:
            return NSLocalizedString("Recovery rate", comment: "")
        case OrePrice:
            return NSLocalizedString("Ore price", comment: "")
        case ProcessingCost:
            return NSLocalizedString("Processing cost", comment: "")
        }
    }
    
    var value: Any {
        switch self {
        case OreGrade(let value):
            return value
        case Capacity(let value):
            return value
        case FinishedProduct(let value):
            return value
        case RecoveryRate(let value):
            return value
        case OrePrice(let value):
            return value
        case ProcessingCost(let value):
            return value
        }
    }
}

class ROICrusherInput: ROIInput {
    var oreGrade: ROICrusherInputValue = .OreGrade(0.60) //%
    var capacity: ROICrusherInputValue = .Capacity(1200) //m t/hr
    var finishedProduct: ROICrusherInputValue = .FinishedProduct(35) //%
    var recoveryRate: ROICrusherInputValue = .RecoveryRate(85) //%
    var orePrice: ROICrusherInputValue = .OrePrice(5500) //USD/m t
    var processingCost: ROICrusherInputValue = .ProcessingCost(10) //USD/m t
    var service: ROICrusherService = .None
    
    
    private func allInputs() -> [ROICrusherInputValue] {
        return [oreGrade, capacity, finishedProduct, recoveryRate, orePrice, processingCost]
    }
    
    override func allTitles() -> [String] {
        var allTitles = [String]()
        let all = allInputs()
        for v in all {
            allTitles.append(v.title)
        }
        return allTitles
    }
    
    override func changeInput(atIndex :Int, change :ChangeInput) -> String {
        var input = allInputs()[atIndex]
        switch input {
        case .OreGrade:
            if change != ChangeInput.Load {
                oreGrade = .OreGrade(input.value as! Double + (change == ChangeInput.Increase ? 0.10 : -0.10))
            }
            return String(format:"%.2f", input.value as! Double) + "%";
        case .Capacity:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    capacity = .Capacity(UInt(value))
                }
            }
            return String(format:"%f", input.value as! UInt) + "%";
        case .FinishedProduct:
            if change != ChangeInput.Load {
                finishedProduct = .OreGrade(input.value as! Double + (change == ChangeInput.Increase ? 0.10 : -0.10))
            }
            return String(format:"%f", input.value as! UInt) + "%";
        case .RecoveryRate:
            if change != ChangeInput.Load {
                recoveryRate = .OreGrade(input.value as! Double + (change == ChangeInput.Increase ? 0.10 : -0.10))
            }
            return String(format:"%f", input.value as! UInt) + "%";
        case .OrePrice:
            if change != ChangeInput.Load {
                orePrice = .OreGrade(input.value as! Double + (change == ChangeInput.Increase ? 0.10 : -0.10))
            }
            return String(format:"%f", input.value as! UInt) + "%";
        case .ProcessingCost:
            if change != ChangeInput.Load {
                input = .OreGrade(input.value as! Double + (change == ChangeInput.Increase ? 0.10 : -0.10))
            }
            return String(format:"%f", input.value as! UInt) + "%";
        }
    }
    
    func finishedProductMTHR() -> UInt {
        if let c = capacity.value as? UInt, f = finishedProduct.value as? UInt {
            return c * (f/100)
        }
        return 0
    }
    
    func additionalTonsOfFinishedProduct() -> UInt {
        return finishedProductMTHR() * service.rawValue
    }
    
    func recoveredProductAfterProcessing() -> Double {
        if let o = oreGrade.value as? Double, r = recoveryRate.value as? UInt {
            return Double(additionalTonsOfFinishedProduct() * (r/100)) * (o/100)
        }
        return 0
    }
    
    func total() -> Double {
        if let o = orePrice.value as? UInt, p = processingCost.value as? UInt {
            let r = recoveredProductAfterProcessing()
            return (r * Double(o)) - (r * Double(p))
        }
        return 0
    }
}