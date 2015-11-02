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
    let content: Content
    
    init(title: String, content: NSDictionary){
        self.title = title
        self.content = Content(content: content)
    }
    
    class Content {
        var title: String? = nil
        var subtitle: String? = nil
        var contentList: [AnyObject] = []
        
        init(content: NSDictionary){
            if let title = content.objectForKey("title") as? String {
                self.title = title
                if let subtitle = content.objectForKey("subTitle") as? String {
                    self.subtitle = subtitle
                }
            }
            if let html = content.objectForKey("content") as? [NSDictionary] {
                for part in html {
                    if let type = part.objectForKey("type") as? String {
                        if type == "lead", let value = part.objectForKey("value") as? String {
                            contentList.append(Lead(text: value))
                        }
                        else if type == "body", let value = part.objectForKey("value") as? String {
                            contentList.append(Body(textWithPossibleTitle: value))
                        }
                        else if type == "key-feature-list", let value = part.objectForKey("value") as? NSDictionary {
                            contentList.append(KeyFeatureListContent(content: value))
                        }
                        else if type == "columns", let value = part.objectForKey("value") as? [NSDictionary] {
                            for d in value {
                                contentList.append(CountOnBoxContent(content: d))
                            }
                        }
                        else if type == "tabbed-content", let value = part.objectForKey("value") as? NSDictionary {
                            contentList.append(TabbedContent(content: value))
                        }
                    }
                }
            }
        }
        
        class CountOnBoxContent {
            var title: String? = nil
            var topText: String? = nil
            var midText: String? = nil
            var bottomText: String? = nil
            
            init(content: NSDictionary){
                if let type = content.objectForKey("type") as? String {
                    if type.caseInsensitiveCompare("body") == .OrderedSame, let title = content.objectForKey("value") as? String {
                        self.title = title
                    }
                    else if type.caseInsensitiveCompare("content") == .OrderedSame, let countonList  = content.objectForKey("value") as? [NSDictionary] {
                        for counton in countonList {
                            if let value = counton.objectForKey("value") as? NSDictionary {
                                if let config = value.objectForKey("config") as? NSDictionary {
                                    if let columns = config.objectForKey("columns") as? [NSDictionary] {
                                        print("columns count", columns.count) //can it be more than one?
                                        if let rows = columns.first?.objectForKey("rows") as? [NSDictionary] {
                                            setTexts(rows)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            private func setTexts(rows: [NSDictionary]) {
                if rows.count == 3 {
                    self.topText = rows[0].objectForKey("text") as? String
                    self.midText = rows[1].objectForKey("text") as? String
                    self.bottomText = rows[2].objectForKey("text") as? String
                }
                else if rows.count == 2 {
                    //check which should be where
                    let firstSize = rows[0].objectForKey("size") as? Int
                    let nextSize = rows[1].objectForKey("size") as? Int
                    if nextSize >= firstSize {
                        self.topText = rows[0].objectForKey("text") as? String
                        self.midText = rows[1].objectForKey("text") as? String
                    }
                    else {
                        self.midText = rows[0].objectForKey("text") as? String
                        self.bottomText = rows[1].objectForKey("text") as? String
                    }
                }
                else if rows.count == 1 {
                    self.midText = rows[1].objectForKey("text") as? String
                }
            }
        }
        
        class KeyFeatureListContent {
            var title: String? = nil
            var texts: [TitleAndText]? = nil
            
            init(content: NSDictionary) {
                if let featureList = content.objectForKey("config") as? [String] {
                    self.texts = []
                    for feature in featureList {
                        if let title = feature.stringBetweenStrongTag() {
                            let text = feature.stringByReplacingOccurrencesOfString(title, withString: "").stripHTML()
                            self.texts!.append(TitleAndText(title: title, text: text))
                        }
                    }
                }
            }
        }
        
        class TabbedContent {
            var tabs: [TitleAndText]? = nil
            
            init(content: NSDictionary) {
                if let tabs = content.objectForKey("config") as? [NSDictionary] {
                    self.tabs = []
                    for tab in tabs {
                        if let title = tab.objectForKey("text") as? String {
                            if let content = tab.objectForKey("content") as? [NSDictionary] {
                                var string: String = ""
                                for text in content {
                                    if let t = text.objectForKey("text") as? String {
                                        string += t
                                        //TODO can it loop ?
                                    }
                                }
                                self.tabs!.append(TitleAndText(title: title, text: string))
                            }
                        }
                    }
                }
            }
        }
        
        class Lead {
            var text: String? = nil
            
            init(text: String) {
                self.text = text.stripHTML()
            }
        }
        
        class Body: TitleAndText {
            
            override init(textWithPossibleTitle: String) {
                super.init(textWithPossibleTitle: textWithPossibleTitle)
            }
        }
        
        class TitleAndText {
            var title: String? = nil
            var text: String? = nil
            
            init(title: String, text: String){
                self.title = title
                self.text = text
            }
            
            init(textWithPossibleTitle: String){
                if let title = textWithPossibleTitle.stringBetweenHeaderTag() {
                    self.title = title.stripHTML()
                    self.text = textWithPossibleTitle.stringByReplacingOccurrencesOfString(title, withString: "").stripHTML()
                }
                else {
                    self.text = textWithPossibleTitle.stripHTML()
                }
            }
        }
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