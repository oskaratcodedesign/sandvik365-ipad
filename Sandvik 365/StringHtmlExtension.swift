//
//  StringHtmlExtension.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 01/11/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation
import UIKit
import Fuzi

extension String {
    
    func stripHTML() -> String {
        do {
            let doc = try HTMLDocument(string: self)
            if let childStr = doc.firstChild(xpath: "//html")?.stringValue {
                return childStr
            }
        } catch {
        }
        return self
    }

}