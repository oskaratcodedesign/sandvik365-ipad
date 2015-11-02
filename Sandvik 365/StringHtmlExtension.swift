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
    
    func stringBetweenHeaderTag() -> String? {
        if let range = self.rangeOfString("(?i)[^.]+(?=</h)", options:.RegularExpressionSearch) {
            return self.substringWithRange(range)
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