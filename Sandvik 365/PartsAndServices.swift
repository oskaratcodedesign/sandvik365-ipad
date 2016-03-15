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
    case CrusherAndScreening
    case ExplorationDrillRigs
    case MechanicalCutting
    //case MineAutomationSystems
    case SurfaceDrilling
    case UndergroundDrillingAndBolting
    case UndergroundLoadingAndHauling
    case All
    
    private static let _count: BusinessType.RawValue = {
        // find the maximum enum value
        var maxValue: UInt32 = 0
        while let _ = BusinessType(rawValue: ++maxValue) { }
        return maxValue - 1 //dont include All
    }()
    
    static func randomBusinessType() -> BusinessType {
        // pick and return a new value
        let rand = arc4random_uniform(_count)
        return BusinessType(rawValue: rand)!
    }
    
    var videos: [Video]? {
        switch self {
        case /*BulkMaterialHandling, ConveyorComponents,*/ ExplorationDrillRigs, CrusherAndScreening:
            return nil
        case UndergroundLoadingAndHauling:
            return [
                Video(videoName: "GET - Bucket Shroud Wear", ext: "mp4", title: "GET - Bucket Shroud Wear", image: "S365-movie-button-bucket-shroud-wear"),
                Video(videoName: "GET - Corner Shroud Installation", ext: "mp4", title: "GET - Corner Shroud Installation", image: "S365-movie-button-corner-shroud-install"),
                Video(videoName: "GET - MHS Installation", ext: "mp4", title: "GET - MHS Installation", image: "S365-movie-button-MHS-installation"),
                Video(videoName: "GET - MHS Removal", ext: "mp4", title: "GET - MHS Removal", image: "S365-movie-button-MHS-deinstallation"),
                Video(videoName: "GET - Sectional Shroud Installation", ext: "mp4", title: "GET - Sectional Shroud Installation", image: "S365-movie-button-Sectional-shroud-install"),
                Video(videoName: "Rebuilds and Major Components", ext: "mp4", title: "Rebuilds and Major Components", image: "rebuilds"),
                Video(videoName: "Eclipse - Fluorine-free fire suppression system", ext: "mp4", title: "Eclipse - Fluorine-free fire suppression system", image: "eclipse")
            ]
        case UndergroundDrillingAndBolting:
            return  [
                Video(videoName: "Rock drill kits - Standardize your repairs", ext: "mp4", title: "Rock drill kits - Standardize your repairs", image: "rockdrillkits"),
                Video(videoName: "Rock drills - Modernize your drilling", ext: "mp4", title: "Rock drills - Modernize your drilling", image: "rockdrill"),
                Video(videoName: "Eclipse - Fluorine-free fire suppression system", ext: "mp4", title: "Eclipse - Fluorine-free fire suppression system", image: "eclipse")
            ]
        case SurfaceDrilling:
            return  [Video(videoName: "Eclipse - Fluorine-free fire suppression system", ext: "mp4", title: "Eclipse - Fluorine-free fire suppression system", image: "eclipse")]
        case MechanicalCutting:
            return  [Video(videoName: "Rebuilds and Major Components", ext: "mp4", title: "Rebuilds and Major Components", image: "rebuilds")]
        case All:
            return [
                Video(videoName: "GET - Bucket Shroud Wear", ext: "mp4", title: "GET - Bucket Shroud Wear", image: "S365-movie-button-bucket-shroud-wear"),
                Video(videoName: "GET - Corner Shroud Installation", ext: "mp4", title: "GET - Corner Shroud Installation", image: "S365-movie-button-corner-shroud-install"),
                Video(videoName: "GET - MHS Installation", ext: "mp4", title: "GET - MHS Installation", image: "S365-movie-button-MHS-installation"),
                Video(videoName: "GET - MHS Removal", ext: "mp4", title: "GET - MHS Removal", image: "S365-movie-button-MHS-deinstallation"),
                Video(videoName: "GET - Sectional Shroud Installation", ext: "mp4", title: "GET - Sectional Shroud Installation", image: "S365-movie-button-Sectional-shroud-install"),
                Video(videoName: "Rebuilds and Major Components", ext: "mp4", title: "Rebuilds and Major Components", image: "rebuilds"),
                Video(videoName: "Eclipse - Fluorine-free fire suppression system", ext: "mp4", title: "Eclipse - Fluorine-free fire suppression system", image: "eclipse"),
                Video(videoName: "Rock drill kits - Standardize your repairs", ext: "mp4", title: "Rock drill kits - Standardize your repairs", image: "rockdrillkits"),
                Video(videoName: "Rock drills - Modernize your drilling", ext: "mp4", title: "Rock drills - Modernize your drilling", image: "rockdrill"),
                Video(videoName: "Eclipse - Fluorine-free fire suppression system", ext: "mp4", title: "Eclipse - Fluorine-free fire suppression system", image: "eclipse")
            ]
        }
    }
    
    var mediaCenterTitle: String? {
        switch self {
        case ExplorationDrillRigs, CrusherAndScreening:
            return nil
        case UndergroundLoadingAndHauling, UndergroundDrillingAndBolting, MechanicalCutting, SurfaceDrilling, All:
            return "Videos & Animations"
        }
    }
    
    var interActiveToolsTitle: String? {
        switch self {
        case ExplorationDrillRigs, CrusherAndScreening, UndergroundLoadingAndHauling, UndergroundDrillingAndBolting, MechanicalCutting, SurfaceDrilling:
            return nil
        case All:
            return "Interactive tools"
        }
    }
    
    var backgroundImageName :String {
        switch self {
        /*case BulkMaterialHandling:
            return "bulk material handling"
        case ConveyorComponents:
            return "conveyors"*/
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
        case All:
            return "service-awareness-underground-2048"
        }
    }
    
    var tagUUID: String? {
        switch self {
        /*case BulkMaterialHandling:
            return nil
        case ConveyorComponents:
            return nil*/
        case CrusherAndScreening:
            return "bda647ec-7ef1-491a-9adc-a915ec5bb745"
        case ExplorationDrillRigs, All:
            return nil
        case MechanicalCutting:
            return "ce360d28-35bc-4578-9e52-79517f769af2"
        /*case MineAutomationSystems:
            return nil*/
        case SurfaceDrilling:
            return "c19dea00-5941-4fce-8a06-add969f41a76"
        case UndergroundDrillingAndBolting:
            return "7b0828b7-0755-4e5c-9c60-cd748c77eec1"
        case UndergroundLoadingAndHauling:
            return "a850e245-fb6d-4232-a855-e572094c7ae9"
        }
    }
    
    var interActiveTools: [InterActiveTools]? {
        switch self {
        case ExplorationDrillRigs, MechanicalCutting, UndergroundDrillingAndBolting:
            return nil
        case SurfaceDrilling:
            return [.RockDrillTool]
        case CrusherAndScreening:
            return [.CrusherTool, .EDVTool]
        case UndergroundLoadingAndHauling:
            return [.GetTool, .FireSuppressionTool]
        case All:
            return [.RockDrillTool, .CrusherTool, .FireSuppressionTool, .EDVTool, .GetTool]
        }
    }
    
    enum InterActiveTools {
        case RockDrillTool
        case CrusherTool
        case FireSuppressionTool
        case EDVTool
        case GetTool
        
        var title: String! {
            switch self {
            case RockDrillTool:
                return "Rock drill upgrade simulator"
            case CrusherTool:
                return "Lifecycle program calculator"
            case FireSuppressionTool:
                return "Fire suppression tool"
            case EDVTool:
                return "Electric dump valve calculator"
            case GetTool:
                return "Ground Engaging Tools (GET) calculator"
            }
        }
        
        var selectionInput: SelectionInput? {
            switch self {
            case RockDrillTool:
                return ROIRockDrillInput()
            case CrusherTool:
                return ROICrusherInput()
            case FireSuppressionTool:
                return JSONManager.getData(JSONManager.EndPoint.FIRESUPPRESSION_URL) as? FireSuppressionInput
            case EDVTool:
                return ROIEDVInput()
            case GetTool:
                return ROIGetInput()
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
    let jsonParts: PartsAndServicesJSONParts
    
    init(businessType: BusinessType, json: PartsAndServicesJSONParts)
    {
        self.businessType = businessType
        self.jsonParts = json
    }
    
    func shouldPartServiceBeShown(ps: PartService) -> Bool {
        if self.businessType != .All, let tagids = ps.productTagUUIDs {
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
        if self.businessType != .All, let tagids = sp.productTagUUIDs {
            if businessType.tagUUID == nil || !tagids.contains(businessType.tagUUID!) {
                return false
            }
        }
        return true
    }
    
    func mainSectionTitles() -> [String] {
        var titles: [String] = []
        
        if let interActiveToolsTitle = self.businessType.interActiveToolsTitle {
            titles.append(interActiveToolsTitle.uppercaseString)
        }
        else if let tools = self.businessType.interActiveTools {
            titles += tools.flatMap({$0.title.uppercaseString})
        }

        if let mediaCenterTitle = self.businessType.mediaCenterTitle {
            titles.append(mediaCenterTitle.uppercaseString)
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