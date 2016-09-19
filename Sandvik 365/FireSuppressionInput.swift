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
    var image: URL?
    
    init(title: String, image: String?) {
        self.title = title
        if let imageurl = image {
            self.image = URL(string: imageurl)
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
    var image: URL?
    var quantity: Int?
    var partNumbers: [String]?
    var sizes: [String]?
    var content: Content?
    
    init(content: NSDictionary){
        if let imageurl = FireSuppressionInput.image(content) {
            self.image = URL(string: imageurl)
        }
        self.quantity = content.object(forKey: "quantity") as? Int
        self.partNumbers = content.object(forKey: "partNumbers") as? [String]
        self.sizes = content.object(forKey: "sizes") as? [String]
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
    
    override func allTitles() -> [String] {
        return [NSLocalizedString("Product group", comment: ""), NSLocalizedString("Equipment type", comment: ""), NSLocalizedString("Model", comment: ""), NSLocalizedString("Lowest temperature", comment: "")]
    }
    
    override func changeInput(_ atIndex :Int, change : ChangeInput) -> String {
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
            if change != ChangeInput.load {
                selectedTemperature = value == .Above ? .Below : .Above
            }
            return selectedTemperature.rawValue
            
        default:
            return ""
        }
    }
    
    fileprivate func getNextIndexFromArray(_ array: [TitleAndImage], title: String, change : ChangeInput) -> Int? {
        if let index = array.index(where: { $0.title == title }) {
            var newindex = index + change.rawValue
            newindex = newindex >= array.count ? 0 : (newindex < 0 ? array.count-1 : newindex)
            return newindex
        }
        else if !array.isEmpty {
            return 0
        }
        return nil
    }
    
    override func getInputAbbreviation(_ atIndex :Int) -> InputAbbreviation? {
        return nil
    }
    
    override func setInput(_ atIndex :Int, stringValue :String) -> Bool {
        return false
    }
    
    override func getInputAsString(_ atIndex :Int) -> String? {
        return nil
    }
    
    init(json: NSDictionary) {
        super.init()
        if let sections = json.value(forKey: "items")?[0].value(forKey: "children") as? [NSDictionary] {
            parseProductGroup(sections)
        }
    }
    
    fileprivate func parseProductGroup(_ sections: [NSDictionary]) {
        for section in sections {
            if let title = title(section) {
                let productGroup = ProductGroup(title: title, image: FireSuppressionInput.image(section))
                if let children = section.value(forKey: "children") as? [NSDictionary] {
                    parseEquipmentType(children, productGroup: productGroup)
                }
                allProductGroups.append(productGroup)
            }
        }
    }
    
    fileprivate func parseEquipmentType(_ sections: [NSDictionary], productGroup: ProductGroup) {
        for section in sections {
            if let title = title(section) {
                let equipmentType = EquipmentType(title: title, image: FireSuppressionInput.image(section))
                if let children = section.value(forKey: "children") as? [NSDictionary] {
                    parseModels(children, equipmentType: equipmentType)
                }
                productGroup.equipmentTypes.append(equipmentType)
            }
        }
    }
    
    fileprivate func parseModels(_ sections: [NSDictionary], equipmentType: EquipmentType) {
        for section in sections {
            if let title = title(section) {
                let model = Model(title: title, image: FireSuppressionInput.image(section))
                equipmentType.models.append(model)
                if let aboveZero = section.value(forKey: "aboveZero") as? NSDictionary {
                    model.aboveZero = BelowAboveOutPut(content: aboveZero)
                }
            }
        }
    }
    
    fileprivate func title(_ dic: NSDictionary) -> String? {
        return dic.value(forKey: "title") as? String
    }
    
    static func image(_ dic: NSDictionary) -> String? {
        return dic.value(forKey: "thumbnail") as? String
    }
    
}
