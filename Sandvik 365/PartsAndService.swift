//
//  Parts.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 25/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation

enum PartType: UInt {
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
        if let videoName = PartType.videos[self] {
            let path = NSBundle.mainBundle().pathForResource(videoName, ofType:"m4v")
            let url = NSURL.fileURLWithPath(path!)
            return url
        }
        return nil
    }
}

class JSONPart {
    let mainSections: [NSDictionary]
    
    init(partType: PartType, json: NSDictionary) {
        //parse out relevant parts:
        if let sections = json.valueForKey("data")?.valueForKey("items")?[0].valueForKey("children") as? [NSDictionary] {
            mainSections = sections
        }
        else {
            mainSections = []
        }
    }
    
    func mainSectionTitles() -> [String] {
        var titles: [String] = []
        for dic in mainSections {
            if let title = dic.valueForKey("title") as? String {
                titles.append(title)
            }
        }
        return titles
    }
}

class PartsAndService {
    let partType: PartType
    let jsonPart: JSONPart
    
    init(partType: PartType, json: NSDictionary)
    {
        self.partType = partType
        self.jsonPart = JSONPart(partType: partType, json: json)
    }
}