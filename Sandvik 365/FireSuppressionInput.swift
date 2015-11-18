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
    case Above = "Above 0 degrees Celsius"
    case Below = "Below 0 degrees Celisus"
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
        return [NSLocalizedString("Product group", comment: ""), NSLocalizedString("Equipment type", comment: ""), NSLocalizedString("Model", comment: ""), NSLocalizedString("Lowest possible operating environment temperature", comment: "")]
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
    
    init(json: NSDictionary?) {
        super.init()
        //TODO parse after download
        if let path = NSBundle.mainBundle().pathForResource("firesuppression", ofType: "json")
        {
            if let d = NSData(contentsOfFile: path)
            {
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(d, options: .MutableContainers) as? NSDictionary {
                        if let sections = json.valueForKey("data")?.valueForKey("items")?[0].valueForKey("children") as? [NSDictionary] {
                            parseProductGroup(sections)
                        }
                    }
                }
                catch {
                    print(error)
                }
            }
        }
    }
    
    private func parseProductGroup(sections: [NSDictionary]) {
        for section in sections {
            if let title = title(section) {
                let productGroup = ProductGroup(title: title, image: image(section))
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
                let equipmentType = EquipmentType(title: title, image: image(section))
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
                let model = Model(title: title, image: image(section))
                equipmentType.models.append(model)
            }
        }
    }
    
    private func title(dic: NSDictionary) -> String? {
        return dic.valueForKey("title") as? String
    }
    
    private func image(dic: NSDictionary) -> String? {
        return dic.valueForKey("thumbnail") as? String
    }
    
}