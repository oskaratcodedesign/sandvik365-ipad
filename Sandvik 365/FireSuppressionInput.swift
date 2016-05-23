//
//  FireSuppressionInput.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 17/11/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation

enum TemperatureType: String {
    //TODO handle farenheit
    case Above = "Above 0°C"
    case Below = "Below 0°C"
}

class TitleAndImage {
    var title: String
    var image: NSURL?
    
    init(title: String, image: String?) {
        self.title = title
        if let imageurl = image {
            self.image = NSURL(string: imageurl)
        }
    }
}

class ProductGroup: TitleAndImage {
    var equipmentTypes:[EquipmentType] = []
}

class EquipmentType: TitleAndImage{
    var models:[Model] = []
}

class Model: TitleAndImage {
    var aboveZero: BelowAboveOutPut?
    var belowZero: BelowAboveOutPut?
}

class BelowAboveOutPut {
    var image: NSURL?
    var quantity: Int?
    var partNumbers: [String]?
    var sizes: [String]?
    var content: Content?
    
    init(content: NSDictionary){
        if let imageurl = FireSuppressionInput.image(content) {
            self.image = NSURL(string: imageurl)
        }
        self.quantity = content.objectForKey("quantity") as? Int
        self.partNumbers = content.objectForKey("partNumbers") as? [String]
        self.sizes = content.objectForKey("sizes") as? [String]
        self.content = Content(content: content)
    }
}

class FireSuppressionInput: SelectionInput {
    var allProductGroups: [ProductGroup] = []
    var allTemperatures: [String] = [TemperatureType.Above.rawValue, TemperatureType.Below.rawValue]
    
    var selectedProductGroup: ProductGroup = ProductGroup(title: "", image: nil)
    var selectedEquipmentType: EquipmentType = EquipmentType(title: "", image: nil)
    var selectedModel: Model = Model(title: "", image: nil)
    var selectedTemperature: TemperatureType = .Above
    
    func allInputs() -> [Any] {
        return [selectedProductGroup, selectedEquipmentType, selectedModel, selectedTemperature]
    }
    
    override func allTitles() -> [NSAttributedString] {
        return [NSAttributedString(string:NSLocalizedString("Product group", comment: "")), NSAttributedString(string:NSLocalizedString("Equipment type", comment: "")), NSAttributedString(string:NSLocalizedString("Model", comment: "")), NSAttributedString(string:NSLocalizedString("Lowest temperature", comment: ""))]
    }
    
    override func changeInput(atIndex :Int, change : ChangeInput) -> String {
        let input = allInputs()[atIndex]
        switch input {
        case let value as ProductGroup:
            if let index = getNextIndexFromArray(allProductGroups, title: value.title, change: change) {
                selectedProductGroup = allProductGroups[index]
            }
            return selectedProductGroup.title
        case let value as EquipmentType:
            if let index = getNextIndexFromArray(selectedProductGroup.equipmentTypes, title: value.title, change: change) {
                selectedEquipmentType = selectedProductGroup.equipmentTypes[index]
            }
            return selectedEquipmentType.title
        case let value as Model:
            if let index = getNextIndexFromArray(selectedEquipmentType.models, title: value.title, change: change) {
                selectedModel = selectedEquipmentType.models[index]
            }
            return selectedModel.title
        case let value as TemperatureType:
            if change != ChangeInput.Load {
                selectedTemperature = value == .Above ? .Below : .Above
            }
            return selectedTemperature.rawValue
            
        default:
            return ""
        }
    }
    
    private func getNextIndexFromArray(array: [TitleAndImage], title: String, change : ChangeInput) -> Int? {
        if let index = array.indexOf({ $0.title == title }) {
            var newindex = index + change.rawValue
            newindex = newindex >= array.count ? 0 : (newindex < 0 ? array.count-1 : newindex)
            return newindex
        }
        else if !array.isEmpty {
            return 0
        }
        return nil
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
        super.init()
        if let sections = json.valueForKey("items")?[0].valueForKey("children") as? [NSDictionary] {
            parseProductGroup(sections)
        }
    }
    
    private func parseProductGroup(sections: [NSDictionary]) {
        for section in sections {
            if let title = title(section) {
                let productGroup = ProductGroup(title: title, image: FireSuppressionInput.image(section))
                if let children = section.valueForKey("children") as? [NSDictionary] {
                    parseEquipmentType(children, productGroup: productGroup)
                }
                allProductGroups.append(productGroup)
            }
        }
    }
    
    private func parseEquipmentType(sections: [NSDictionary], productGroup: ProductGroup) {
        for section in sections {
            if let title = title(section) {
                let equipmentType = EquipmentType(title: title, image: FireSuppressionInput.image(section))
                if let children = section.valueForKey("children") as? [NSDictionary] {
                    parseModels(children, equipmentType: equipmentType)
                }
                productGroup.equipmentTypes.append(equipmentType)
            }
        }
    }
    
    private func parseModels(sections: [NSDictionary], equipmentType: EquipmentType) {
        for section in sections {
            if let title = title(section) {
                let model = Model(title: title, image: FireSuppressionInput.image(section))
                equipmentType.models.append(model)
                if let aboveZero = section.valueForKey("aboveZero") as? NSDictionary {
                    model.aboveZero = BelowAboveOutPut(content: aboveZero)
                }
            }
        }
    }
    
    private func title(dic: NSDictionary) -> String? {
        return dic.valueForKey("title") as? String
    }
    
    static func image(dic: NSDictionary) -> String? {
        return dic.valueForKey("thumbnail") as? String
    }
    
}