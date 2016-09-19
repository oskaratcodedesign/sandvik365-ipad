//
//  PartServiceContent.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 17/11/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation
import Fuzi

class PartServiceContent {
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
    var images: [URL] = []
    var pdfs: [Pdf] = []
    
    init(content: NSDictionary){
        if let title = content.object(forKey: "title") as? String {
            self.title = title.stripHTML()
            if let subtitle = content.object(forKey: "subTitle") as? String {
                self.subtitle = subtitle.stripHTML()
            }
        }
        if let html = content.object(forKey: "content") as? [NSDictionary] {
            for part in html {
                if let type = part.object(forKey: "type") as? String {
                    if type == "lead", let value = part.object(forKey: "value") as? [NSDictionary] {
                        contentList.append(Lead(content: parseTitleTextList(value)))
                    }
                    else if type == "body", let value = part.object(forKey: "value") as? [NSDictionary] {
                        contentList.append(Body(content: parseTitleTextList(value)))
                    }
                    else if type == "key-feature-list", let value = part.object(forKey: "value") as? NSDictionary {
                        contentList.append(KeyFeatureListContent(content: value))
                    }
                    else if type == "columns", let value = part.object(forKey: "value") as? [NSDictionary] {
                        parseColumns(value)
                    }
                    else if type == "tabbed-content", let value = part.object(forKey: "value") as? NSDictionary {
                        contentList.append(TabbedContent(content: value))
                    }
                }
            }
        }
        
        if let images = content.object(forKey: "images") as? NSDictionary, let heroImage = images.object(forKey: "hero") as? String {
            if let imageUrl = URL(string: heroImage) {
                self.images.append(imageUrl)
            }
        }
    }
    
    fileprivate func parseColumns(_ content: [NSDictionary]){
        for part in content {
            if let type = part.object(forKey: "type") as? String {
                if type == "lead", let value = part.object(forKey: "value") as? [NSDictionary] {
                    contentList.append(Lead(content: parseTitleTextList(value)))
                }
                else if type == "body", let value = part.object(forKey: "value") as? [NSDictionary] {
                    contentList.append(Body(content: parseTitleTextList(value)))
                }
                else if type == "key-feature-list", let value = part.object(forKey: "value") as? NSDictionary {
                    contentList.append(KeyFeatureListContent(content: value))
                }
                else if type == "content", let value = part.object(forKey: "value") as? [NSDictionary] {
                    contentList.append(CountOnBoxContent(content: value))
                }
                else if type == "tabbed-content", let value = part.object(forKey: "value") as? NSDictionary {
                    contentList.append(TabbedContent(content: value))
                }
            }
        }
    }
    
    class CountOnBoxContent {
        var title: String? = nil
        var texts: [CountOnBoxText] = []
        
        class CountOnBoxText{
            var text: String
            var size: Int = 0
            var isLargest = false
            
            init(text: String, size: Int){
                self.text = text
                self.size = size
            }
        }
        
        internal func largestBox() -> CountOnBoxText?{
            let largestBox = texts.max(by: { (a, b) -> Bool in
                return a.size < b.size
            })
            return largestBox
        }
        
        internal func allSmallTextBelowLargest() -> String?{
            var text: String? = nil
            var largestFound = false
            for c in texts {
                if c.isLargest {
                    largestFound = true
                    continue
                }
                if largestFound && !c.isLargest {
                    let t = c.text.trimmingCharacters(
                        in: CharacterSet.whitespacesAndNewlines
                    )
                    text = text == nil ? t : (text! + " " + t)
                }
            }
            return text
        }
        
        init(content: [NSDictionary]){
            for part in content {
                if let type = part.object(forKey: "type") as? String {
                    /*if type.caseInsensitiveCompare("body") == .OrderedSame, let title = part.objectForKey("value") as? String {
                        self.title = title.stripHTML()
                    }*/
                    if type.caseInsensitiveCompare("count-on") == .orderedSame, let value = part.object(forKey: "value") as? NSDictionary {
                        if let config = value.object(forKey: "config") as? NSDictionary {
                            if let columns = config.object(forKey: "columns") as? [NSDictionary] {
                                //print("columns count", columns.count) //can it be more than one?
                                if let rows = columns.first?.object(forKey: "rows") as? [NSDictionary] {
                                    setTexts(rows)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        fileprivate func setTexts(_ rows: [NSDictionary]) {
            for row in rows {
                if let text = textFromObj(row), let size = row.object(forKey: "size") as? Int {
                    texts.append(CountOnBoxText(text: text, size: size))
                }
            }
            if let largestBox = largestBox() {
                largestBox.isLargest = true
            }
        }
        
        fileprivate func textFromObj(_ obj: NSDictionary) -> String? {
            if let string = obj.object(forKey: "text") as? String {
                return string.stripHTML()
            }
            return nil
        }
    }
    
    class KeyFeatureListContent {
        var title: String? = nil
        var texts: [TitleAndText]? = nil
        
        init(content: NSDictionary) {
            if let title = content.object(forKey: "title") as? String {
                self.title = title.stripHTML()
            }
            if let featureList = content.object(forKey: "config") as? [String] {
                self.texts = []
                for feature in featureList {
                    do {
                        let doc = try HTMLDocument(string: feature)
                        let title = doc.firstChild(xpath: "//p/strong")?.stringValue
                        let text = doc.firstChild(xpath: "//following-sibling::text()[normalize-space()]")?.stringValue
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
            if let tabs = content.object(forKey: "config") as? [NSDictionary] {
                self.tabs = []
                for tab in tabs {
                    if let title = tab.object(forKey: "text") as? String {
                        if let content = tab.object(forKey: "content") as? [NSDictionary] {
                            var string: String = ""
                            for text in content {
                                if let t = text.object(forKey: "text") as? String {
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
        let titleOrTextOrList: [TitleTextOrList]
        
        init(content: [TitleTextOrList]) {
            self.titleOrTextOrList = content
        }
    }
    
    class Body {
        let titleOrTextOrList: [TitleTextOrList]
        init(content: [TitleTextOrList]) {
            self.titleOrTextOrList = content
        }
    }
    
    class Pdf {
        let title: String
        let url: URL
        
        init(title: String, url: URL){
            self.title = title
            self.url = url
        }
    }
    
    fileprivate func parseTitleTextList(_ content: [NSDictionary]) -> [TitleTextOrList] {
        var titleOrTextOrList: [TitleTextOrList] = []
        for part in content {
            if let type = part.object(forKey: "element") as? String {
                if type == "p", let value = part.object(forKey: "html") as? String {
                    do {
                        let doc = try HTMLDocument(string: value)
                        if let href = doc.root?.firstChild(xpath: "//a") {
                            if let link = href.attr("href") {
                                if link.hasSuffix("pdf") {
                                    let title = href.stringValue
                                    if let url = URL(string: link) {
                                        self.pdfs.append(Pdf(title: title, url: url))
                                        continue
                                    }
                                }
                            }
                        }
                    } catch {
                        print("failed to parse pdf")
                    }
                    let string = value.stripHTML()
                    if(string.characters.count > 0 && string.trimmingCharacters(in: CharacterSet.whitespaces).characters.count > 0) {
                        titleOrTextOrList.append(.text(string))
                    }
                }
                else if ["h1", "h2", "h3", "h4", "h5", "h6"].contains(type), let value = part.object(forKey: "html") as? String {
                    titleOrTextOrList.append(.title(value.stripHTML()))
                }
                else if type == "ul", let value = part.object(forKey: "items") as? [String] {
                    var titleText = [TitleAndText]()
                    for string in value {
                        do {
                            let doc = try HTMLDocument(string: string)
                            let title = doc.firstChild(xpath: "//em")?.stringValue
                            var text: String? = nil
                            if title != nil {
                                text = doc.firstChild(xpath: "//following-sibling::text()[normalize-space()]")?.stringValue
                            }
                            else {
                                text = doc.firstChild(xpath: "//text()")?.stringValue
                            }
                            if text != nil {
                                titleText.append(TitleAndText(title: title, text: text!))
                            }
                        } catch {
                            print("failed to parse list html")
                        }
                    }
                    if titleText.count > 0 {
                        titleOrTextOrList.append(.list(titleText))
                    }
                }
            }
        }
        return titleOrTextOrList
    }
    
    enum TitleTextOrList {
        case title(String)
        case text(String)
        case list([TitleAndText])
    }
    
    class TitleAndText {
        var title: String? = nil
        var text: String? = nil
        
        init(title: String?, text: String){
            if title != nil {
                self.title = title!.stripHTML()
            }
            self.text = text.stripHTML()
        }
    }
}
