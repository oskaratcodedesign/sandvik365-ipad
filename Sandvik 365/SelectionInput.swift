//
//  ROICalculator.swift
//  Sandvik 365
//
//  Created by Karl Söderström on 10/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation
import UIKit

enum ChangeInput: Int{
    case increase = 1
    case decrease = -1
    case load = 0
}

enum InputAbbreviation: String {
    case Percent = "%"
    case PPM = "ppm"
    case USD = " USD"
    case USDHour = " USD/hour"
    case USDOunce = " USD/oz"
    case USDton = " USD/t"
    case TonPerDay = "t/d"
    case TonPerHour = "t/h"
    case Gram = "g"
    case Kilo = "kg"
    case Meter = "m"
    case Year = "/year"
    case Minutes = "min"
    
    func addAbbreviation(_ value: String, valueFont: UIFont, abbreviationFont: UIFont) ->  NSAttributedString{
        let attrString = NSMutableAttributedString(string: value, attributes: [NSFontAttributeName:valueFont])
        switch self {
        case .Percent, .PPM, .USD,.USDOunce, .USDton, .TonPerDay, .TonPerHour, .Gram, .Kilo, .Meter, .Year, .USDHour, .Minutes:
            attrString.append(NSAttributedString(string: self.rawValue, attributes: [NSFontAttributeName:abbreviationFont]))
        }
        return attrString
    }
}

class SelectionInput {
    
    func allTitles() -> [String] {
        preconditionFailure("This method must be overridden")
    }
    
    func changeInput(_ atIndex :Int, change : ChangeInput) -> String {
        preconditionFailure("This method must be overridden")
    }
    
    func getInputAbbreviation(_ atIndex :Int) -> InputAbbreviation? {
        preconditionFailure("This method must be overridden")
    }
    
    /* returns false if setting input from string fails */
    func setInput(_ atIndex :Int, stringValue :String) -> Bool {
        preconditionFailure("This method must be overridden")
    }
    
    /* returns nil if input cant be modified */
    func getInputAsString(_ atIndex :Int) -> String? {
        preconditionFailure("This method must be overridden")
    }
    
}
