//
//  PartServiceContent.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 17/11/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation
import Fuzi

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
    let productTagUUIDs: [String]?
    var content: Content? = nil
    var subPartsServices: [SubPartService]? = nil
    
    init(title: String, description: String, productTagUUIDs: [String]?){
        self.title = title
        self.description = description
        self.productTagUUIDs = productTagUUIDs
    }
}

class SubPartService {
    let title: String
    let content: Content
    let productTagUUIDs: [String]?
    
    init(title: String, content: NSDictionary, productTagUUIDs: [String]?){
        self.title = title
        self.content = Content(content: content)
        self.productTagUUIDs = productTagUUIDs
    }
    
}

class Content {
    var title: String? = nil
    var subtitle: String? = nil
    var contentList: [AnyObject] = []
    var images: [NSURL] = []
    
    init(content: NSDictionary){
        if let title = content.objectForKey("title") as? String {
            self.title = title.stripHTML()
            if let subtitle = content.objectForKey("subTitle") as? String {
                self.subtitle = subtitle.stripHTML()
            }
        }
        if let html = content.objectForKey("content") as? [NSDictionary] {
            for part in html {
                if let type = part.objectForKey("type") as? String {
                    if type == "lead", let value = part.objectForKey("value") as? String {
                        contentList.append(Lead(text: value))
                    }
                    else if type == "body", let value = part.objectForKey("value") as? String {
                        contentList.append(Body(text: value))
                    }
                    else if type == "key-feature-list", let value = part.objectForKey("value") as? NSDictionary {
                        contentList.append(KeyFeatureListContent(content: value))
                    }
                    else if type == "columns", let value = part.objectForKey("value") as? [NSDictionary] {
                        contentList.append(CountOnBoxContent(content: value))
                    }
                    else if type == "tabbed-content", let value = part.objectForKey("value") as? NSDictionary {
                        contentList.append(TabbedContent(content: value))
                    }
                }
            }
        }
        
        if let images = content.objectForKey("images") as? NSDictionary, let heroImage = images.objectForKey("hero") as? String {
            if let imageUrl = NSURL(string: heroImage) {
                self.images.append(imageUrl)
            }
        }
    }
    
    class CountOnBoxContent {
        var title: String? = nil
        var topText: String? = nil
        var midText: String? = nil
        var bottomText: String? = nil
        
        init(content: [NSDictionary]){
            for part in content {
                if let type = part.objectForKey("type") as? String {
                    if type.caseInsensitiveCompare("body") == .OrderedSame, let title = part.objectForKey("value") as? String {
                        self.title = title.stripHTML()
                    }
                    else if type.caseInsensitiveCompare("content") == .OrderedSame, let countonList  = part.objectForKey("value") as? [NSDictionary] {
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
        }
        
        private func setTexts(rows: [NSDictionary]) {
            if rows.count == 3 {
                self.topText = textFromObj(rows[0])
                self.midText = textFromObj(rows[1])
                self.bottomText = textFromObj(rows[2])
            }
            else if rows.count == 2 {
                //check which should be where
                let firstSize = rows[0].objectForKey("size") as? Int
                let nextSize = rows[1].objectForKey("size") as? Int
                if nextSize >= firstSize {
                    self.topText = textFromObj(rows[0])
                    self.midText = textFromObj(rows[1])
                }
                else {
                    self.midText = textFromObj(rows[0])
                    self.bottomText = textFromObj(rows[1])
                }
            }
            else if rows.count == 1 {
                self.midText = textFromObj(rows[0])
            }
        }
        
        private func textFromObj(obj: NSDictionary) -> String? {
            if let string = obj.objectForKey("text") as? String {
                return string.stripHTML()
            }
            return nil
        }
    }
    
    class KeyFeatureListContent {
        var title: String? = nil
        var texts: [TitleAndText]? = nil
        
        init(content: NSDictionary) {
            if let title = content.objectForKey("title") as? String {
                self.title = title.stripHTML()
            }
            if let featureList = content.objectForKey("config") as? [String] {
                self.texts = []
                for feature in featureList {
                    do {
                        let doc = try HTMLDocument(string: feature)
                        let title = doc.firstChild(xpath: "//p/strong")?.stringValue
                        let text = doc.firstChild(xpath: "//p/text()")?.stringValue
                        if title != nil && text != nil {
                            self.texts!.append(TitleAndText(title: title!, text: text!))
                        }
                    } catch {
                        print("failed to parse html")
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
    
    class Body {
        var titlesAndText: [TitleAndText] = []
        
        init(text: String) {
            do {
                let doc = try HTMLDocument(string: text)
                let headers = doc.xpath("//*[self::h1 or self::h2 or self::h3 or self::h4 or self::h5 or self::h6]")
                for header in headers {
                    let title = header.stringValue
                    let text = header.nextSibling?.stringValue
                    
                    if text != nil {
                        self.titlesAndText.append(TitleAndText(title: title, text: text!))
                    }
                }
            } catch {
                print("failed to parse html")
            }
        }
    }
    
    class TitleAndText {
        var title: String? = nil
        var text: String? = nil
        
        init(title: String, text: String){
            self.title = title.stripHTML()
            self.text = text.stripHTML()
        }
    }
}
