//
//  NSNumberFormatterExtension.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 27/11/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation

extension NumberFormatter {
    
    func formatterDecimalWith2Fractions() -> NumberFormatter {
        self.numberStyle = .decimal
        self.maximumFractionDigits = 2
        return self
    }
    
    func formatToUSD(number: NSNumber) -> String {
        self.numberStyle = .currency
        self.currencyCode = "USD"
        self.maximumFractionDigits = 0
        return self.string(from: number) ?? ""
    }
    
}
