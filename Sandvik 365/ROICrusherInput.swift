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
    case RampUp = 14
    case ConditionInspection = 1
    case MaintenancePlanning = 7
    //case Protective
}

enum OperationType: String {
    case New = "New"
    case Established = "Established"
}

enum ROICrusherInputValue {
    case Operation(OperationType)
    case Capacity(UInt)
    case OreGrade(Double)
    //case FinishedProduct(UInt)
    case RecoveryRate(Double)
    case OrePrice(UInt)
    //case ProcessingCost(UInt)

    var title :String {
        switch self {
        case Operation:
            return NSLocalizedString("Operation", comment: "")
        case OreGrade:
            return NSLocalizedString("Ore grade", comment: "")
        case Capacity:
            return NSLocalizedString("Crushing capacity", comment: "")
        /*case FinishedProduct:
            return NSLocalizedString("Finished product from crushing plant", comment: "")*/
        case RecoveryRate:
            return NSLocalizedString("Recovery rate", comment: "")
        case OrePrice:
            return NSLocalizedString("Market price", comment: "")
        /*case ProcessingCost:
            return NSLocalizedString("Processing cost", comment: "")*/
        }
    }
    
    var value: Any {
        switch self {
        case Operation(let value):
            return value
        case OreGrade(let value):
            return value
        case Capacity(let value):
            return value
        /*case FinishedProduct(let value):
            return value*/
        case RecoveryRate(let value):
            return value
        case OrePrice(let value):
            return value
        /*case ProcessingCost(let value):
            return value*/
        }
    }
}

class ROICrusherInput: ROIInput {
    var operation: ROICrusherInputValue = .Operation(OperationType.New)
    var oreGrade: ROICrusherInputValue = .OreGrade(0.60) //%
    var capacity: ROICrusherInputValue = .Capacity(1200) //m t/hr
    //var finishedProduct: ROICrusherInputValue = .FinishedProduct(35) //%
    var recoveryRate: ROICrusherInputValue = .RecoveryRate(85) //%
    var orePrice: ROICrusherInputValue = .OrePrice(5500) //USD/m t
    //var processingCost: ROICrusherInputValue = .ProcessingCost(10) //USD/m t
    var services: Set<ROICrusherService> = Set<ROICrusherService>()
    var usePPM: Bool = false //otherwise percent
    let months: UInt = 12
    let startMonth: UInt = 3
    
    func allInputs() -> [ROICrusherInputValue] {
        return [operation, capacity, oreGrade, recoveryRate, orePrice]
    }
    
    override func allTitles() -> [String] {
        var allTitles = [String]()
        let all = allInputs()
        for v in all {
            allTitles.append(v.title)
        }
        return allTitles
    }
    
    override func setInput(atIndex :Int, stringValue :String) -> Bool {
        let input = allInputs()[atIndex]
        switch input {
        case .Operation:
            return false
        case .OreGrade:
            if var number = nsNumberFormatterDecimalWith2Fractions().numberFromString(stringValue) {
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
        /*case .FinishedProduct:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                finishedProduct = .FinishedProduct(number.unsignedLongValue)
                return true
            }*/
        case .RecoveryRate:
            if let number = nsNumberFormatterDecimalWith2Fractions().numberFromString(stringValue) {
                recoveryRate = .RecoveryRate(number.doubleValue)
                return true
            }
        case .OrePrice:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                orePrice = .OrePrice(number.unsignedLongValue)
                return true
            }
        /*case .ProcessingCost:
            if let number = NSNumberFormatter().numberFromString(stringValue) {
                processingCost = .ProcessingCost(number.unsignedLongValue)
                return true
            }*/
        }
        
        return false
    }
    
    private func nsNumberFormatterDecimalWith2Fractions() -> NSNumberFormatter {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    override func getInputAsString(atIndex :Int) -> String? {
        let input = allInputs()[atIndex]
        switch input {
        case .Operation:
            return nil
        case .OreGrade:
            var value = oreGrade.value as! Double
            if usePPM {
                value = 10000 * value
            }
            return nsNumberFormatterDecimalWith2Fractions().stringFromNumber(value)
        case .Capacity:
            return NSNumberFormatter().stringFromNumber(capacity.value as! UInt)
        /*case .FinishedProduct:
            return NSNumberFormatter().stringFromNumber(finishedProduct.value as! UInt)*/
        case .RecoveryRate:
            return nsNumberFormatterDecimalWith2Fractions().stringFromNumber(recoveryRate.value as! Double)
        case .OrePrice:
            return NSNumberFormatter().stringFromNumber(orePrice.value as! UInt)
        /*case .ProcessingCost:
            return NSNumberFormatter().stringFromNumber(processingCost.value as! UInt)*/
        }
    }

    
    override func changeInput(atIndex :Int, change :ChangeInput) -> NSAttributedString {
        let input = allInputs()[atIndex]
        switch input {
        case .Operation:
            let value = operation.value as! OperationType
            if change != ChangeInput.Load {
                if value == .New {
                    operation = .Operation(.Established)
                }
                else {
                    operation = .Operation(.New)
                }
                self.services.removeAll() //clear when operation change
            }
            let typeString: String = (operation.value as! OperationType).rawValue
            let attrString = NSMutableAttributedString(string: typeString, attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            return attrString
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
            var value = oreGrade.value as! Double
            var valueType: String = "%"
            if usePPM {
                value = value * 10000
                valueType = "ppm"
            }
            let attrString = NSMutableAttributedString(string: (nsNumberFormatterDecimalWith2Fractions().stringFromNumber(value) ?? "") + valueType, attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "AktivGroteskCorp-Light", size: 1.0)!, range: NSRange(location: attrString.length-valueType.characters.count,length: valueType.characters.count))
            return attrString
        case .Capacity:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    capacity = .Capacity(UInt(value))
                }
            }
            let valueType: String = "m t/d"
            let attrString = NSMutableAttributedString(string: String(capacity.value as! UInt) + valueType, attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "AktivGroteskCorp-Light", size: 1.0)!, range: NSRange(location: attrString.length-valueType.characters.count,length: valueType.characters.count))
            return attrString
        /*case .FinishedProduct:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    finishedProduct = .FinishedProduct(UInt(value))
                }
            }
            let valueType: String = "%"
            let attrString = NSMutableAttributedString(string: String(finishedProduct.value as! UInt) + valueType, attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "AktivGroteskCorp-Light", size: 1.0)!, range: NSRange(location: attrString.length-valueType.characters.count,length: valueType.characters.count))
            return attrString*/
        case .RecoveryRate:
            if change != ChangeInput.Load {
                let value = input.value as! Double + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    recoveryRate = .RecoveryRate(value)
                }
            }
            let valueType: String = "%"
            let attrString = NSMutableAttributedString(string: (nsNumberFormatterDecimalWith2Fractions().stringFromNumber(recoveryRate.value as! Double) ?? "") + valueType, attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "AktivGroteskCorp-Light", size: 1.0)!, range: NSRange(location: attrString.length-valueType.characters.count,length: valueType.characters.count))
            return attrString
        case .OrePrice:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    orePrice = .OrePrice(UInt(value))
                }
            }
            let valueType: String = usePPM ? "USD/ounce" : "USD/ton"
            let attrString = NSMutableAttributedString(string: String(orePrice.value as! UInt) + valueType, attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "AktivGroteskCorp-Light", size: 1.0)!, range: NSRange(location: attrString.length-valueType.characters.count,length: valueType.characters.count))
            return attrString
        /*case .ProcessingCost:
            if change != ChangeInput.Load {
                let value = Int(input.value as! UInt) + (change == ChangeInput.Increase ? 1 : -1)
                if value >= 0 {
                    processingCost = .ProcessingCost(UInt(value))
                }
            }
            let valueType: String = "$"
            let attrString = NSMutableAttributedString(string: valueType + String(processingCost.value as! UInt), attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 2.0)!])
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "AktivGroteskCorp-Light", size: 1.0)!, range: NSRange(location: 0,length: valueType.characters.count))
            return attrString*/
        }
    }
    
    /*func finishedProductMTHR() -> Double {
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
    }*/
    
    override func total() -> Int {
        var result: Int = 0
        let tonnage = capacity.value as! UInt
        let oregrade = oreGrade.value as! Double
        let recoverrate = recoveryRate.value as! Double
        let marketPrice = orePrice.value as! UInt
        
        if let service = services.first {
            let res = (Double(tonnage) * (Double(oregrade)/100) * (Double(recoverrate)/100) * Double(marketPrice)) * Double(service.rawValue)
            if res > Double(Int.max) {
                result = Int.max
            }
            else {
                result = Int(res)
            }
        }
        return result
    }
    
    override func maxTotal() -> Double {
        let currentServices = services
        services = [.RampUp]
        let result = Double(total())
        services = currentServices
        return result
    }
    
    override func originalTotal() -> [Int] {
        let currentServices = services
        services = []
        
        let t = total()
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
        let t = total()
        var totals = [Int]()
        let len = months-1
        for i in 0...len {
            if i > len/4 {
                if i < len-len/4 {
                    totals.append(t)
                }
                else {
                    totals.append(-1)
                }
            }
            else {
                totals.append(0)
            }
        }
        return totals
        /*if services.contains(.RampUp) {
            totals = originalTotal()
            let newStartMonth = startMonth - 1
            totals[Int(newStartMonth)] = totals.last!
            if services.contains(.MaintenancePlanning) {
                let currentServices = services
                services = [.MaintenancePlanning]
                t = total()
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
                t = total()
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
        return totals*/
    }
    
    override func graphScale() -> CGFloat {
        return 2
    }
}