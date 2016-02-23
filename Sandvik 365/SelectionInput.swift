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
    case Increase = 1
    case Decrease = -1
    case Load = 0
}

enum InputAbbreviation: String {
    case Percent = "%"
    case PPM = "ppm"
    case USD = " USD"
    case USDHour = " USD/hour"
    case USDOunce = " USD/oz"
    case USDton = " USD/t"
    case MillionTonPerDay = "mt/d"
    case Gram = "g"
    case Kilo = "kg"
    case Meter = "m"
    case Year = "/year"
    
    func addAbbreviation(value: String, valueFont: UIFont, abbreviationFont: UIFont) ->  NSAttributedString{
        let attrString = NSMutableAttributedString(string: value, attributes: [NSFontAttributeName:valueFont])
        switch self {
        case .Percent, .PPM, .USD,.USDOunce, .USDton, .MillionTonPerDay, .Gram, .Kilo, .Meter, .Year, .USDHour:
            attrString.appendAttributedString(NSAttributedString(string: self.rawValue, attributes: [NSFontAttributeName:abbreviationFont]))
        }
        return attrString
    }
}

class SelectionInput {
    
    func allTitles() -> [String] {
        preconditionFailure("This method must be overridden")
    }
    
    func changeInput(atIndex :Int, change : ChangeInput) -> String {
        preconditionFailure("This method must be overridden")
    }
    
    func getInputAbbreviation(atIndex :Int) -> InputAbbreviation? {
        preconditionFailure("This method must be overridden")
    }
    
    /* returns false if setting input from string fails */
    func setInput(atIndex :Int, stringValue :String) -> Bool {
        preconditionFailure("This method must be overridden")
    }
    
    /* returns nil if input cant be modified */
    func getInputAsString(atIndex :Int) -> String? {
        preconditionFailure("This method must be overridden")
    }
    
}