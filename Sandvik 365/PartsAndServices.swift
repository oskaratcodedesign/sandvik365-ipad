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
    var levelOneSectionTitles: [String] = []
    let levelTwoSectionTitlesAndDescriptions: NSMutableDictionary = NSMutableDictionary()
    let levelThreeSectionTitles: NSMutableDictionary = NSMutableDictionary()
    
    init(businessType: BusinessType, json: NSDictionary) {
        
        //parse out relevant parts:
        levelOneSectionTitles(json)
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
    
    private func levelOneSectionTitles(json: NSDictionary) {
        if let sections = levelOneSections(json) {
            for dic in sections {
                if let title = sectionTitle(dic) {
                    levelOneSectionTitles.append(title.uppercaseString)
                    
                    if let jsonpart = dic.valueForKey("children") as? [NSDictionary] {
                        levelTwoSectionTitlesAndDescriptions(jsonpart, levelOneTitle: title)
                    }
                }
            }
        }
    }
    
    private func levelTwoSectionTitlesAndDescriptions(jsonpart: [NSDictionary], levelOneTitle: String){
        var titlesAndDesc: [NSDictionary] = []
        for dic in jsonpart {
            if let title = sectionTitle(dic) {
                let titleDesc = NSMutableDictionary(object: title.uppercaseString, forKey: "title")
                if let desc = sectionDescription(dic) {
                    titleDesc.setObject(desc, forKey: "description")
                }
                titlesAndDesc.append(titleDesc)
                if let jsonpart = dic.valueForKey("children") as? [NSDictionary] {
                    levelThreeSectionTitles(jsonpart, levelTwoTitle: title)
                }
            }
        }
        levelTwoSectionTitlesAndDescriptions.setObject(titlesAndDesc, forKey: levelOneTitle.uppercaseString)
    }
    
    private func levelThreeSectionTitles(jsonpart: [NSDictionary], levelTwoTitle: String) {
        var titles: [String] = []
        for dic in jsonpart {
            if let title = sectionTitle(dic) {
                titles.append(title.uppercaseString)
            }
        }
        levelThreeSectionTitles.setObject(titles, forKey: levelTwoTitle.uppercaseString)
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
        return jsonParts.levelOneSectionTitles
    }
    
    func partServiceTitlesAndDescriptions(sectionTitle: String) -> [NSDictionary] {
        return jsonParts.levelTwoSectionTitlesAndDescriptions.objectForKey(sectionTitle) as! [NSDictionary]
    }
    
    func subPartServicTitles(sectionTitle: String) -> [String] {
        return jsonParts.levelThreeSectionTitles.objectForKey(sectionTitle) as! [String]
    }
}