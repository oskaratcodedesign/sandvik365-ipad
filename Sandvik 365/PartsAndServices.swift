//
//  Parts.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 25/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation

enum BusinessType: UInt32 {
    //case BulkMaterialHandling
    //case ConveyorComponents
    case crusherAndScreening
    case explorationDrillRigs
    case mechanicalCutting
    //case MineAutomationSystems
    case surfaceDrilling
    case undergroundDrillingAndBolting
    case undergroundLoadingAndHauling
    case all
    
    static func randomBusinessType() -> BusinessType {
        // pick and return a new value
        let count = all.rawValue
        let rand = arc4random_uniform(count)
        return BusinessType(rawValue: rand)!
    }
    
    var videos: [Video]? {
        switch self {
        case /*BulkMaterialHandling, ConveyorComponents,*/ .explorationDrillRigs:
            return nil
        case .crusherAndScreening:
            return [Videos.edv_FINAL.video]
        case .undergroundLoadingAndHauling:
            return [
                Videos.get_BUCKET_SHROUD.video, Videos.get_CORNER_SHROUD.video, Videos.get_MHS_INSTALL.video, Videos.get_MHS_REMOVAL.video, Videos.get_SECTIONAL_SHROUD.video, Videos.eclipse.video, Videos.rebuilds.video
            ]
        case .undergroundDrillingAndBolting:
            return [
                Videos.rock_DRILL_KITS.video, Videos.rock_DRILLS.video, Videos.eclipse.video
            ]
        case .surfaceDrilling:
            return [Videos.eclipse.video]
        case .mechanicalCutting:
            return [Videos.rebuilds.video]
        case .all:
            return [
                Videos.get_BUCKET_SHROUD.video, Videos.get_CORNER_SHROUD.video, Videos.get_MHS_INSTALL.video, Videos.get_MHS_REMOVAL.video, Videos.get_SECTIONAL_SHROUD.video, Videos.eclipse.video, Videos.rebuilds.video,  Videos.rock_DRILL_KITS.video, Videos.rock_DRILLS.video, Videos.edv_FINAL.video
            ]
        }
    }
    
    var mediaCenterTitle: String? {
        switch self {
        case .explorationDrillRigs:
            return nil
        case .crusherAndScreening, .undergroundLoadingAndHauling, .undergroundDrillingAndBolting, .mechanicalCutting, .surfaceDrilling, .all:
            return "Videos & Animations"
        }
    }
    
    var interActiveToolsTitle: String? {
        switch self {
        case .explorationDrillRigs, .crusherAndScreening, .undergroundLoadingAndHauling, .undergroundDrillingAndBolting, .mechanicalCutting, .surfaceDrilling:
            return nil
        case .all:
            return "Interactive tools"
        }
    }
    
    var backgroundImageName :String {
        switch self {
        /*case BulkMaterialHandling:
            return "bulk material handling"
        case ConveyorComponents:
            return "conveyors"*/
        case .crusherAndScreening:
            return "crushing and screening"
        case .explorationDrillRigs:
            return "exploration drilling"
        case .mechanicalCutting:
            return "mechanical cutting"
        /*case MineAutomationSystems:
            return "automation systems"*/
        case .surfaceDrilling:
            return "surface drilling"
        case .undergroundDrillingAndBolting:
            return "underground drilling bolting"
        case .undergroundLoadingAndHauling:
            return "underground hauling"
        case .all:
            return "service-awareness-underground-2048"
        }
    }
    
    var tagUUID: String? {
        switch self {
        /*case BulkMaterialHandling:
            return nil
        case ConveyorComponents:
            return nil*/
        case .crusherAndScreening:
            return "bda647ec-7ef1-491a-9adc-a915ec5bb745"
        case .explorationDrillRigs, .all:
            return nil
        case .mechanicalCutting:
            return "ce360d28-35bc-4578-9e52-79517f769af2"
        /*case MineAutomationSystems:
            return nil*/
        case .surfaceDrilling:
            return "c19dea00-5941-4fce-8a06-add969f41a76"
        case .undergroundDrillingAndBolting:
            return "7b0828b7-0755-4e5c-9c60-cd748c77eec1"
        case .undergroundLoadingAndHauling:
            return "a850e245-fb6d-4232-a855-e572094c7ae9"
        }
    }
    
    var interActiveTools: [InterActiveTool]? {
        switch self {
        case .explorationDrillRigs, .mechanicalCutting:
            return [.serviceKitQuantifier]
        case .undergroundDrillingAndBolting:
            return [.topCenterTool, .serviceKitQuantifier]
        case .surfaceDrilling:
            return [.serviceKitQuantifier]//[.RockDrillTool]
        case .crusherAndScreening:
            return [.crusherTool, .edvTool, .serviceKitQuantifier]
        case .undergroundLoadingAndHauling:
            return [.getTool/*, .FireSuppressionTool*/, .serviceKitQuantifier]
        case .all:
            return [/*.RockDrillTool, .FireSuppressionTool,*/ .topCenterTool, .crusherTool, .edvTool, .getTool, .serviceKitQuantifier]
        }
    }
    
    enum InterActiveTool {
        //case RockDrillTool
        case crusherTool
        //case FireSuppressionTool
        case edvTool
        case getTool
        case topCenterTool
        case serviceKitQuantifier
        
        var title: String! {
            switch self {
            /*case RockDrillTool:
                return "Rock drill upgrade simulator"
            case FireSuppressionTool:
                return "Fire suppression tool"*/
            case .topCenterTool:
                return "Top center calculator"
            case .crusherTool:
                return "Lifecycle program calculator"
            case .edvTool:
                return "Electric dump valve calculator"
            case .getTool:
                return "Ground Engaging Tools (GET) calculator"
            case .serviceKitQuantifier:
                return "Maintenance kit quantifier"
            }
        }
        
        var defaultImage: UIImage? {
            switch self {
            case /*RockDrillTool,*/ .topCenterTool, .crusherTool, .edvTool, .getTool:
                return UIImage(named: "calculator-x1")
            case .serviceKitQuantifier /*FireSuppressionTool*/:
                return UIImage(named: "options-x1")
            }
        }
        
        var highlightImage: UIImage? {
            switch self {
            case /*RockDrillTool,*/ .topCenterTool, .crusherTool, .edvTool, .getTool:
                return UIImage(named: "calculator-inverted-x1")
            case .serviceKitQuantifier /*FireSuppressionTool*/:
                return UIImage(named: "options-inverted-x1")
            }
        }
        
        var selectionInput: AnyObject? {
            switch self {
            /*case RockDrillTool:
                return ROIRockDrillInput()
            case FireSuppressionTool:
                return JSONManager.getData(JSONManager.EndPoint.FIRESUPPRESSION_URL) as? FireSuppressionInput*/
            case .topCenterTool:
                return ROITopCenterInput()
            case .crusherTool:
                return ROICrusherInput()
            case .edvTool:
                return ROIEDVInput()
            case .getTool:
                return ROIGetInput()
            case .serviceKitQuantifier:
                return nil
            }
        }
    }
}

class PartsAndServicesJSONParts {
    var partsServicesContent: [PartServiceContent] = []
    
    init(json: NSDictionary) {
        //parse out relevant parts:
        parseMainSections(json)
    }
    
    fileprivate func sectionTitle(_ dic: NSDictionary) -> String? {
        return dic.value(forKey: "navTitle") as? String
    }
    
    fileprivate func sectionDescription(_ dic: NSDictionary) -> String? {
        return dic.value(forKey: "description") as? String
    }
    
    fileprivate func mainSections(_ json: NSDictionary) -> [NSDictionary]? {
        if let sections = json.value(forKey: "items")?[0].value(forKey: "children") as? [NSDictionary] {
            return sections
        }
        return nil
    }
    
    fileprivate func parseMainSections(_ json: NSDictionary) {
        if let sections = mainSections(json) {
            for dic in sections {
                if let title = sectionTitle(dic) {
                    let partServiceContent = PartServiceContent(title: title)
                    
                    if let jsonpart = dic.value(forKey: "children") as? [NSDictionary] {
                        parsePartServiceSections(jsonpart, partServiceContent: partServiceContent)
                    }
                    partsServicesContent.append(partServiceContent)
                }
            }
        }
    }
    
    fileprivate func parsePartServiceSections(_ jsonpart: [NSDictionary], partServiceContent: PartServiceContent) {
        for dic in jsonpart {
            if let title = sectionTitle(dic), let desc = sectionDescription(dic) {
                let partService = PartService(title: title, description: desc, productTagUUIDs: getProductTagIds(dic))
                if let jsonpart = dic.value(forKey: "children") as? [NSDictionary] {
                    parseSubPartServiceSections(jsonpart, partService: partService)
                }
                else if dic.object(forKey: "content") != nil {
                    partService.content = Content(content: dic)
                }
                partServiceContent.partsServices.append(partService)
            }
        }
    }
    
    fileprivate func getProductTagIds(_ dic: NSDictionary) -> [String]? {
        var productIds: [String]? = nil
        if let products = dic.object(forKey: "products") as? [NSDictionary] {
            let pids = products.map({(product) -> String? in product["id"] as? String })
            if pids.count > 0 {
                productIds = pids.flatMap({ $0 })
            }
        }
        return productIds
    }
    
    fileprivate func parseSubPartServiceSections(_ jsonpart: [NSDictionary], partService: PartService) {
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
    let jsonParts: PartsAndServicesJSONParts
    
    init(businessType: BusinessType, json: PartsAndServicesJSONParts)
    {
        self.businessType = businessType
        self.jsonParts = json
    }
    
    func shouldPartServiceBeShown(_ ps: PartService) -> Bool {
        if self.businessType != .all, let tagids = ps.productTagUUIDs {
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
    
    func shouldSubPartServiceBeShown(_ sp: SubPartService) -> Bool {
        if self.businessType != .all, let tagids = sp.productTagUUIDs {
            if businessType.tagUUID == nil || !tagids.contains(businessType.tagUUID!) {
                return false
            }
        }
        return true
    }
    
    func mainSectionTitles() -> [String] {
        var titles: [String] = []
        
        if let interActiveToolsTitle = self.businessType.interActiveToolsTitle {
            titles.append(interActiveToolsTitle.uppercased())
        }
        else if let tools = self.businessType.interActiveTools {
            titles += tools.flatMap({$0.title.uppercased()})
        }

        if let mediaCenterTitle = self.businessType.mediaCenterTitle {
            titles.append(mediaCenterTitle.uppercased())
        }
        
        for mp in jsonParts.partsServicesContent {
            for ps in mp.partsServices {
                if(shouldPartServiceBeShown(ps)) {
                    titles.append(mp.title.uppercased())
                    break
                }
            }
        }
        return titles
    }
    
    func partsServices(_ mainSectionTitle: String) -> [PartService]? {
        for mp in jsonParts.partsServicesContent {
            if mp.title.caseInsensitiveCompare(mainSectionTitle) == .orderedSame {
                return mp.partsServices
            }
        }
        return nil
    }
    
    func subPartsServices(_ mainSectionTitle: String, partServicesectionTitle: String) -> [SubPartService]? {
        if let partsServices = partsServices(mainSectionTitle) {
            for ps in partsServices {
                if ps.title.caseInsensitiveCompare(partServicesectionTitle) == .orderedSame {
                    return ps.subPartsServices
                }
            }
        }
        return nil
    }
}
