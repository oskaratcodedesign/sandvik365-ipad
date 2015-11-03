//
//  StringHtmlExtension.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 01/11/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func stringBetweenStrongTag() -> String? {
        if let range = self.rangeOfString("(?i)(?<=<strong>)[^.]+(?=</strong>)", options:.RegularExpressionSearch) {
            return self.substringWithRange(range)
        }
        return nil
    }
    
    func stringUntilNextHeaderTag() -> String {
        if let range = self.rangeOfString("<h(1|2|3|4|5|6)", options:.RegularExpressionSearch) {
            return self.substringToIndex(range.startIndex)
        }
        return self
    }
    
    func stringsWithHeaderTag() -> [String]? {
        do {
            let regex = try NSRegularExpression(pattern: "(?=<h(1|2|3|4|5|6))[^.]+(?=</h(1|2|3|4|5|6))", options: [])
            let nsString = self as NSString
            let results = regex.matchesInString(self,
                options: [], range: NSMakeRange(0, self.characters.count))
            return results.map { nsString.substringWithRange($0.range)}
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func stripHTML() -> String {
        return self.stringByReplacingOccurrencesOfString("<[^>]+>|&nbsp;", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: nil).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    func stripHTMLWithAttributedString() -> String {
        let encodedData = self.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions : [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        do {
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            return attributedString.string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        } catch {
            print(error)
        }
        return self
    }

}