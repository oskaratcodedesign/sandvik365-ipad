//
//  FireSuppressionInput.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 17/11/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation

enum TemperatureType: String {
    case Above = "Above 0 degrees %s"
    case Below = "Below 0 degrees %s"
}

enum FireSuppressionInputValue {
    case ProductGroup(String)
    case EquipmentType(String)
    case Model(String)
    case Temperature(TemperatureType)
    
    var title :String {
        switch self {
        case ProductGroup:
            return NSLocalizedString("Product group", comment: "")
        case EquipmentType:
            return NSLocalizedString("Equipment type", comment: "")
        case Model:
            return NSLocalizedString("Model", comment: "")
        case Temperature:
            return NSLocalizedString("Lowest possible operating environment temperature", comment: "")
        }
    }
    
    var value: String {
        switch self {
        case ProductGroup(let value):
            return value
        case EquipmentType(let value):
            return value
        case Model(let value):
            return value
        case Temperature(let value):
            return value.rawValue
        }
    }
}

class FireSuppressionInput: SelectionInput {
    var allProductGroups: [String]?
    var allEquipmentTypes: [String]?
    var allModels: [String]?
    var allTemperatures: [String] = [TemperatureType.Above.rawValue, TemperatureType.Below.rawValue]
    
    var productGroup: FireSuppressionInputValue = .ProductGroup("")
    var equipmentType: FireSuppressionInputValue = .EquipmentType("")
    var model: FireSuppressionInputValue = .Model("")
    var temperature: FireSuppressionInputValue = .Temperature(.Above)
    
    func allInputs() -> [FireSuppressionInputValue] {
        return [productGroup, equipmentType, model, temperature]
    }
    
    override func allTitles() -> [String] {
        return allInputs().flatMap({ $0.title })
    }
    
    override func changeInput(atIndex :Int, change : ChangeInput) -> String {
        let input = allInputs()[atIndex]
        switch input {
        case .ProductGroup:
            if var index = allProductGroups?.indexOf(input.value) {
                index = index + change.rawValue
                index = allProductGroups!.count >= index ? 0 : (index < 0 ? allProductGroups!.count : index)
            }
            return productGroup.value
        case .EquipmentType:
            return equipmentType.value
        case .Model:
            return model.value
        case .Temperature:
            return temperature.value
        }
        
    }
    
    override func getInputAbbreviation(atIndex :Int) -> InputAbbreviation? {
        return nil
    }
    
    override func setInput(atIndex :Int, stringValue :String) -> Bool {
        return false
    }
    
    override func getInputAsString(atIndex :Int) -> String? {
        return nil
    }
    
    init(json: NSDictionary) {
        
    }
}