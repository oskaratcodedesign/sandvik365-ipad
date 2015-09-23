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
    case ConditionInspection = 8
    case MaintenancePlanning = 80
    //case Protective
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
    var services: Set<ROICrusherService> = Set<ROICrusherService>()
    let months: UInt = 24
    let startMonth: UInt = 4
    
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
    
    override func changeInput(atIndex :Int, change :ChangeInput) -> NSAttributedString {
        let input = allInputs()[atIndex]
        switch input {
        case .OreGrade:
            if change != ChangeInput.Load {
                let value = input.value as! Double + (change == ChangeInput.Increase ? 0.10 : -0.10)
                if value >= 0 {
                    oreGrade = .OreGrade(value)
                }
            }
            let valueType: String = "%"
            let attrString = NSMutableAttributedString(string: String(format:"%.2f", oreGrade.value as! Double) + valueType, attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "AktivGroteskCorp-Light", size: 1.0)!, range: NSRange(location: attrString.length-valueType.characters.count,length: valueType.characters.count))
            return attrString
        case .Capacity:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    capacity = .Capacity(UInt(value))
                }
            }
            let valueType: String = "m t/hr"
            let attrString = NSMutableAttributedString(string: String(capacity.value as! UInt) + valueType, attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "AktivGroteskCorp-Light", size: 1.0)!, range: NSRange(location: attrString.length-valueType.characters.count,length: valueType.characters.count))
            return attrString
        case .FinishedProduct:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    finishedProduct = .Capacity(UInt(value))
                }
            }
            let valueType: String = "%"
            let attrString = NSMutableAttributedString(string: String(finishedProduct.value as! UInt) + valueType, attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "AktivGroteskCorp-Light", size: 1.0)!, range: NSRange(location: attrString.length-valueType.characters.count,length: valueType.characters.count))
            return attrString
        case .RecoveryRate:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    recoveryRate = .RecoveryRate(UInt(value))
                }
            }
            let valueType: String = "%"
            let attrString = NSMutableAttributedString(string: String(recoveryRate.value as! UInt) + valueType, attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "AktivGroteskCorp-Light", size: 1.0)!, range: NSRange(location: attrString.length-valueType.characters.count,length: valueType.characters.count))
            return attrString
        case .OrePrice:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    orePrice = .OrePrice(UInt(value))
                }
            }
            let valueType: String = "$"
            let attrString = NSMutableAttributedString(string: valueType + String(orePrice.value as! UInt), attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "AktivGroteskCorp-Light", size: 1.0)!, range: NSRange(location: 0,length: valueType.characters.count))
            return attrString
        case .ProcessingCost:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    processingCost = .ProcessingCost(UInt(value))
                }
            }
            let valueType: String = "$"
            let attrString = NSMutableAttributedString(string: valueType + String(processingCost.value as! UInt), attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "AktivGroteskCorp-Light", size: 1.0)!, range: NSRange(location: 0,length: valueType.characters.count))
            return attrString
        }
    }
    
    func finishedProductMTHR() -> Double {
        if let c = capacity.value as? UInt, f = finishedProduct.value as? UInt {
            return Double(c) * (Double(f)/100)
        }
        return 0
    }
    
    func additionalTonsOfFinishedProduct() -> Double {
        var totalServiceValue: UInt = 0
        for service in services {
            totalServiceValue += service.rawValue
        }
        return finishedProductMTHR() * Double(totalServiceValue == 0 ? 1 : totalServiceValue)
    }
    
    func recoveredProductAfterProcessing() -> Double {
        if let o = oreGrade.value as? Double, r = recoveryRate.value as? UInt {
            return (additionalTonsOfFinishedProduct() * (Double(r)/100)) * (o/100)
        }
        return 0
    }
    
    override func total() -> Double {
        var result: Double = 0
        if let o = orePrice.value as? UInt, p = processingCost.value as? UInt {
            let r = recoveredProductAfterProcessing()
            result = (r * Double(o)) - (r * Double(p))
        }
        return result
    }
    
    override func maxTotal() -> Double {
        let currentServices = services
        services = [.MaintenancePlanning]
        var result: Double = 0
        if let o = orePrice.value as? UInt, p = processingCost.value as? UInt {
            let r = recoveredProductAfterProcessing()
            result = (r * Double(o)) - (r * Double(p))
        }
        services = currentServices
        return result
    }
    
    override func originalTotal() -> [Int] {
        let currentServices = services
        services = []
        
        let t = Int(total())
        var totals = [Int]()
        for i in 0...months-1 {
            if i >= startMonth {
                totals.append(t)
            }
            else {
                totals.append(0)
            }
        }
        services = currentServices
        return totals
    }
    
    override func calculatedTotal() -> [Int] {
        var t = Int(total())
        var totals = [Int]()
        
        if services.contains(.RampUp) {
            totals = originalTotal()
            let newStartMonth = startMonth - 1
            totals[Int(newStartMonth)] = totals.last!
            if services.contains(.MaintenancePlanning) {
                let currentServices = services
                services = [.MaintenancePlanning]
                t = Int(total())
                for i in 0...months-1 {
                    if i >= newStartMonth {
                        totals[Int(i)] = t
                    }
                    else {
                        totals[Int(i)] = 0
                    }
                }
                services = currentServices
            }
            else if services.contains(.ConditionInspection){
                let currentServices = services
                services = [.ConditionInspection]
                t = Int(total())
                for i in 0...months-1 {
                    if i >= newStartMonth {
                        totals[Int(i)] = t
                    }
                    else {
                        totals[Int(i)] = 0
                    }
                }
                services = currentServices
            }
        }
        else {
            if services.contains(.MaintenancePlanning) {
                for i in 0...months-1 {
                    if i >= startMonth {
                        totals.append(t)
                    }
                    else {
                        totals.append(-1)//so graph will make straight line
                    }
                }
            }
            else if services.contains(.ConditionInspection){
                for i in 0...months-1 {
                    if i >= startMonth {
                        totals.append(t)
                    }
                    else {
                        totals.append(-1)
                    }
                }
            }
        }

        /*for
        switch service {
        case .RampUp:
            totals = originalTotal()
            let newStartMonth = startMonth - 1
            totals[Int(newStartMonth)] = totals.last!
            return totals // only shows timespan
        case .MaintenancePlanning:
            for i in 0...months-1 {
                if i >= startMonth-1 {
                    totals.append(t)
                }
                else {
                    totals.append(0)
                }
            }
            return totals
        case .ConditionInspection:
            for i in 0...months-1 {
                if i >= startMonth-1 {
                    totals.append(t)
                }
                else {
                    totals.append(0)
                }
            }
            return totals
        }*/
        return totals
    }
}