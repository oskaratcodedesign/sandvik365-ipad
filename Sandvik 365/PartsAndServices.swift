//
//  Parts.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 25/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation

enum BusinessType: UInt {
    case BulkMaterialHandling
    case ConveyorComponents
    case CrusherAndScreening
    case ExplorationDrillRigs
    case MechanicalCutting
    case MineAutomationSystems
    case SurfaceDrilling
    case UndergroundDrillingAndBolting
    case UndergroundLoadingAndHauling
    case None
    
    static let allValues = [BulkMaterialHandling, ConveyorComponents, CrusherAndScreening, None]
    
    //TODO return from case
    static let videos = [BulkMaterialHandling : "Sandvik365_Extern_150917"]
    
    func videoURL() -> NSURL? {
        if let videoName = BusinessType.videos[self] {
            let path = NSBundle.mainBundle().pathForResource(videoName, ofType:"m4v")
            let url = NSURL.fileURLWithPath(path!)
            return url
        }
        return nil
    }
}

class MainPartService {
    let title: String
    var partsServices: [PartService] = []
    
    init(title: String){
        self.title = title
    }
}

class PartService {
    let title: String
    let description: String
    var subPartsServices: [SubPartService] = []
    
    init(title: String, description: String){
        self.title = title
        self.description = description
    }
}

class SubPartService {
    let title: String
    let content: NSDictionary
    
    init(title: String, content: NSDictionary){
        self.title = title
        self.content = content
    }
}

class JSONParts {
    var allParts: [MainPartService] = []
    
    init(businessType: BusinessType, json: NSDictionary) {
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
        if let sections = json.valueForKey("data")?.valueForKey("items")?[0].valueForKey("children") as? [NSDictionary] {
            return sections
        }
        return nil
    }
    
    private func parseMainSections(json: NSDictionary) {
        if let sections = mainSections(json) {
            for dic in sections {
                if let title = sectionTitle(dic) {
                    let mainPartService = MainPartService(title: title)
                    
                    if let jsonpart = dic.valueForKey("children") as? [NSDictionary] {
                        parsePartServiceSections(jsonpart, mainPartService: mainPartService)
                    }
                    allParts.append(mainPartService)
                }
            }
        }
    }
    
    private func parsePartServiceSections(jsonpart: [NSDictionary], mainPartService: MainPartService) {
        for dic in jsonpart {
            if let title = sectionTitle(dic), let desc = sectionDescription(dic) {
                let partService = PartService(title: title, description: desc)
                if let jsonpart = dic.valueForKey("children") as? [NSDictionary] {
                    parseSubPartServiceSections(jsonpart, partService: partService)
                }
                mainPartService.partsServices.append(partService)
            }
        }
    }
    
    private func parseSubPartServiceSections(jsonpart: [NSDictionary], partService: PartService) {
        for dic in jsonpart {
            if let title = sectionTitle(dic) {
                let subPartService = SubPartService(title: title, content: dic)
                partService.subPartsServices.append(subPartService)
            }
        }
    }
}

class PartsAndServices {
    let businessType: BusinessType
    let jsonParts: JSONParts
    
    init(businessType: BusinessType, json: NSDictionary)
    {
        self.businessType = businessType
        self.jsonParts = JSONParts(businessType: businessType, json: json)
    }
    
    func mainSectionTitles() -> [String] {
        var titles: [String] = []
        for mp in jsonParts.allParts {
            titles.append(mp.title.uppercaseString)
        }
        return titles
    }
    
    func partsServices(mainSectionTitle: String) -> [PartService]? {
        for mp in jsonParts.allParts {
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