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

class JSONParts {
    let businessType: BusinessType
    
    init(businessType: BusinessType) {
        self.businessType = businessType
    }
    
    private func sectionTitle(dic: NSDictionary) -> String? {
        return dic.valueForKey("navTitle") as? String
    }
    
    private func sectionDescription(dic: NSDictionary) -> String? {
        return dic.valueForKey("description") as? String
    }
    
    private func levelOneSections(json: NSDictionary) -> [NSDictionary]? {
        if let sections = json.valueForKey("data")?.valueForKey("items")?[0].valueForKey("children") as? [NSDictionary] {
            return sections
        }
        return nil
    }
    
    func levelOneSectionTitles(json: NSDictionary) -> [String] {
        var titles: [String] = []
        if let sections = levelOneSections(json) {
            for dic in sections {
                if let title = sectionTitle(dic) {
                    titles.append(title.uppercaseString)
                }
            }
        }
        return titles
    }
    
    private func levelTwoSections(json: NSDictionary, levelOneSectionTitle: String) -> [NSDictionary]? {
        if let sections = levelOneSections(json) {
            for dic in sections {
                if let title = sectionTitle(dic) {
                    if levelOneSectionTitle.caseInsensitiveCompare(title) == .OrderedSame  {
                        return dic.valueForKey("children") as? [NSDictionary]
                    }
                }
            }
        }
        return nil
    }
    
    func levelTwoSectionTitlesAndDescriptions(json: NSDictionary, levelOneSectionTitle: String) -> [NSDictionary] {
        var titlesAndDesc: [NSDictionary] = []
        if let sections = levelTwoSections(json, levelOneSectionTitle: levelOneSectionTitle) {
            for dic in sections {
                if let title = sectionTitle(dic) {
                    let titleDesc = NSMutableDictionary(object: title.uppercaseString, forKey: "title")
                    if let desc = sectionDescription(dic) {
                        titleDesc.setObject(desc, forKey: "description")
                    }
                    titlesAndDesc.append(titleDesc)
                }
            }
        }
        return titlesAndDesc
    }
}

class PartsAndServices {
    let businessType: BusinessType
    let jsonParts: JSONParts
    
    init(businessType: BusinessType)
    {
        self.businessType = businessType
        self.jsonParts = JSONParts(businessType: businessType)
    }
    
    func mainSectionTitles(json: NSDictionary) -> [String] {
        return jsonParts.levelOneSectionTitles(json)
    }
    
    func partServiceTitlesAndDescriptions(json: NSDictionary, sectionTitle: String) -> [NSDictionary] {
        return jsonParts.levelTwoSectionTitlesAndDescriptions(json, levelOneSectionTitle: sectionTitle)
    }
}