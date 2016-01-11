//
//  Parts.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 25/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation

enum BusinessType: UInt32 {
    case BulkMaterialHandling
    case ConveyorComponents
    case CrusherAndScreening
    case ExplorationDrillRigs
    case MechanicalCutting
    //case MineAutomationSystems
    case SurfaceDrilling
    case UndergroundDrillingAndBolting
    case UndergroundLoadingAndHauling
    
    private static let _count: BusinessType.RawValue = {
        // find the maximum enum value
        var maxValue: UInt32 = 0
        while let _ = BusinessType(rawValue: ++maxValue) { }
        return maxValue
    }()
    
    static func randomBusinessType() -> BusinessType {
        // pick and return a new value
        let rand = arc4random_uniform(_count)
        return BusinessType(rawValue: rand)!
    }
    
    var videos: [Video]? {
        switch self {
        case BulkMaterialHandling, ConveyorComponents, ExplorationDrillRigs, MechanicalCutting, SurfaceDrilling, UndergroundDrillingAndBolting, CrusherAndScreening:
            return nil
        case UndergroundLoadingAndHauling:
            return [Video(videoName: "Bucket Shroud Wear Movie Release 01_v1", ext: "mp4", title: ""),
            Video(videoName: "Corner Shroud Installation_v1", ext: "mp4", title: ""),
            Video(videoName: "MHS Install 1920x1080_v1", ext: "mp4", title: ""),
            Video(videoName: "MHS Remove 1920x1080_v1", ext: "mp4", title: ""),
            Video(videoName: "Sectional Shroud Install_v1", ext: "mp4", title: "")]
        }
    }
    
    var backgroundImageName :String {
        switch self {
        case BulkMaterialHandling:
            return "bulk material handling"
        case ConveyorComponents:
            return "conveyors"
        case CrusherAndScreening:
            return "crushing and screening"
        case ExplorationDrillRigs:
            return "exploration drilling"
        case MechanicalCutting:
            return "mechanical cutting"
        /*case MineAutomationSystems:
            return "automation systems"*/
        case SurfaceDrilling:
            return "surface drilling"
        case UndergroundDrillingAndBolting:
            return "underground drilling bolting"
        case UndergroundLoadingAndHauling:
            return "underground hauling"
        }
    }
    
    var tagUUID: String? {
        switch self {
        case BulkMaterialHandling:
            return nil
        case ConveyorComponents:
            return nil
        case CrusherAndScreening:
            return "bda647ec-7ef1-491a-9adc-a915ec5bb745"
        case ExplorationDrillRigs:
            return nil
        case MechanicalCutting:
            return "ce360d28-35bc-4578-9e52-79517f769af2"
        /*case MineAutomationSystems:
            return nil*/
        case SurfaceDrilling:
            return "c19dea00-5941-4fce-8a06-add969f41a76"
        case UndergroundDrillingAndBolting:
            return "1cecb185-c7ab-4e69-a81f-bdea800ba1f1"
        case UndergroundLoadingAndHauling:
            return "a850e245-fb6d-4232-a855-e572094c7ae9"
        }
    }
    
    var roiCrusherCalculatorTitle: String? {
        switch self {
        case BulkMaterialHandling, ConveyorComponents, ExplorationDrillRigs, MechanicalCutting, SurfaceDrilling, UndergroundDrillingAndBolting, UndergroundLoadingAndHauling:
            return nil
        case CrusherAndScreening:
            return "Lifecycle program calculator"
        }
    }
    
    var roiCrusherInput: ROICrusherInput? {
        switch self {
        case BulkMaterialHandling, ConveyorComponents, ExplorationDrillRigs, MechanicalCutting, SurfaceDrilling, UndergroundDrillingAndBolting, UndergroundLoadingAndHauling:
            return nil
        case CrusherAndScreening:
            return ROICrusherInput()
        }
    }
    
    var fireSuppressionInput: FireSuppressionInput? {
        switch self {
        case BulkMaterialHandling, ConveyorComponents, CrusherAndScreening, ExplorationDrillRigs, MechanicalCutting, SurfaceDrilling, UndergroundDrillingAndBolting:
            return nil
        case UndergroundLoadingAndHauling:
            return JSONManager.getJSONParts()?.fireSuppressionInput
        }
    }
    
    var fireSuppressionTitle: String? {
        switch self {
        case BulkMaterialHandling, ConveyorComponents, CrusherAndScreening, ExplorationDrillRigs, MechanicalCutting, SurfaceDrilling, UndergroundDrillingAndBolting:
            return nil
        case UndergroundLoadingAndHauling:
            return "Fire suppression tool"
        }
    }
    
    var roiGetCalculatorTitle: String? {
        switch self {
        case BulkMaterialHandling, ConveyorComponents, ExplorationDrillRigs, MechanicalCutting, SurfaceDrilling, UndergroundDrillingAndBolting, CrusherAndScreening:
            return nil
        case UndergroundLoadingAndHauling:
            return "GET calculator"
        }
    }
    
    var roiGetInput: ROIGetInput? {
        switch self {
        case BulkMaterialHandling, ConveyorComponents, ExplorationDrillRigs, MechanicalCutting, SurfaceDrilling, UndergroundDrillingAndBolting, CrusherAndScreening:
            return nil
        case UndergroundLoadingAndHauling:
            return ROIGetInput()
        }
    }
    
    var roiTitlesLowerCase: [String] {
        return [roiCrusherCalculatorTitle?.lowercaseString, fireSuppressionTitle?.lowercaseString, roiGetCalculatorTitle?.lowercaseString].flatMap({$0})
    }
    
}

class JSONParts {
    var partsServicesContent: [PartServiceContent] = []
    var fireSuppressionInput: FireSuppressionInput?
    
    init(json: NSDictionary) {
        //parse out relevant parts:
        parseMainSections(json)
        if let path = NSBundle.mainBundle().pathForResource("firesuppression", ofType: "json")
        {
            if let d = NSData(contentsOfFile: path)
            {
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(d, options: .MutableContainers) as? NSDictionary {
                        fireSuppressionInput = FireSuppressionInput(json: json)
                    }
                }
                catch {
                    print(error)
                }
            }
        }
    }
    
    private func sectionTitle(dic: NSDictionary) -> String? {
        return dic.valueForKey("navTitle") as? String
    }
    
    private func sectionDescription(dic: NSDictionary) -> String? {
        return dic.valueForKey("description") as? String
    }
    
    private func mainSections(json: NSDictionary) -> [NSDictionary]? {
        if let sections = json.valueForKey("items")?[0].valueForKey("children") as? [NSDictionary] {
            return sections
        }
        return nil
    }
    
    private func parseMainSections(json: NSDictionary) {
        if let sections = mainSections(json) {
            for dic in sections {
                if let title = sectionTitle(dic) {
                    let partServiceContent = PartServiceContent(title: title)
                    
                    if let jsonpart = dic.valueForKey("children") as? [NSDictionary] {
                        parsePartServiceSections(jsonpart, partServiceContent: partServiceContent)
                    }
                    partsServicesContent.append(partServiceContent)
                }
            }
        }
    }
    
    private func parsePartServiceSections(jsonpart: [NSDictionary], partServiceContent: PartServiceContent) {
        for dic in jsonpart {
            if let title = sectionTitle(dic), let desc = sectionDescription(dic) {
                let partService = PartService(title: title, description: desc, productTagUUIDs: getProductTagIds(dic))
                if let jsonpart = dic.valueForKey("children") as? [NSDictionary] {
                    parseSubPartServiceSections(jsonpart, partService: partService)
                }
                else if dic.objectForKey("content") != nil {
                    partService.content = Content(content: dic)
                }
                partServiceContent.partsServices.append(partService)
            }
        }
    }
    
    private func getProductTagIds(dic: NSDictionary) -> [String]? {
        var productIds: [String]? = nil
        if let products = dic.objectForKey("products") as? [NSDictionary] {
            let pids = products.map({(product) -> String? in product["id"] as? String })
            if pids.count > 0 {
                productIds = pids.flatMap({ $0 })
            }
        }
        return productIds
    }
    
    private func parseSubPartServiceSections(jsonpart: [NSDictionary], partService: PartService) {
        for dic in jsonpart {
            if let title = sectionTitle(dic) {
                let subPartService = SubPartService(title: title, content: dic, productTagUUIDs: getProductTagIds(dic))
                if partService.subPartsServices == nil {
                    partService.subPartsServices = []
                }
                partService.subPartsServices!.append(subPartService)
            }
        }
    }
}

class PartsAndServices {
    let businessType: BusinessType
    let jsonParts: JSONParts
    
    init(businessType: BusinessType, json: JSONParts)
    {
        self.businessType = businessType
        self.jsonParts = json
    }
    
    func shouldPartServiceBeShown(ps: PartService) -> Bool {
        if let tagids = ps.productTagUUIDs {
            if businessType.tagUUID == nil || !tagids.contains(businessType.tagUUID!) {
                return false
            }
        }
        if let subPartServices = ps.subPartsServices {
            let countFalse = subPartServices.reduce(0){ $0 + (!self.shouldSubPartServiceBeShown($1) ? 1 : 0)}
            if subPartServices.count == countFalse {
                return false
            }
        }
        return true
    }
    
    func shouldSubPartServiceBeShown(sp: SubPartService) -> Bool {
        if let tagids = sp.productTagUUIDs {
            if businessType.tagUUID == nil || !tagids.contains(businessType.tagUUID!) {
                return false
            }
        }
        return true
    }
    
    func mainSectionTitles() -> [String] {
        var titles: [String] = []
        
        if let roiTitle = self.businessType.roiCrusherCalculatorTitle {
            titles.append(roiTitle.uppercaseString)
        }
        if let fireSuppressionTitle = self.businessType.fireSuppressionTitle {
            titles.append(fireSuppressionTitle.uppercaseString)
        }
        
        if let geTitle = self.businessType.roiGetCalculatorTitle {
            titles.append(geTitle.uppercaseString)
        }
        
        for mp in jsonParts.partsServicesContent {
            for ps in mp.partsServices {
                if(shouldPartServiceBeShown(ps)) {
                    titles.append(mp.title.uppercaseString)
                    break
                }
            }
        }
        return titles
    }
    
    func partsServices(mainSectionTitle: String) -> [PartService]? {
        for mp in jsonParts.partsServicesContent {
            if mp.title.caseInsensitiveCompare(mainSectionTitle) == .OrderedSame {
                return mp.partsServices
            }
        }
        return nil
    }
    
    func subPartsServices(mainSectionTitle: String, partServicesectionTitle: String) -> [SubPartService]? {
        if let partsServices = partsServices(mainSectionTitle) {
            for ps in partsServices {
                if ps.title.caseInsensitiveCompare(partServicesectionTitle) == .OrderedSame {
                    return ps.subPartsServices
                }
            }
        }
        return nil
    }
}