//
//  NSNumberFormatterExtension.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 27/11/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation

extension NSNumberFormatter {
    
    func formatterDecimalWith2Fractions() -> NSNumberFormatter {
        self.numberStyle = .DecimalStyle
        self.maximumFractionDigits = 2
        return self
    }
    
    func formatToUSD(number: NSNumber) -> String {
        self.numberStyle = .CurrencyStyle
        self.currencyCode = "USD"
        return self.stringFromNumber(number) ?? ""
    }
    
}