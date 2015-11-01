//
//  KeyFeatureList.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 30/10/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation
import NibDesignable

class KeyFeatureList: NibDesignable {

    @IBOutlet var keyFeatureItems: [KeyFeatureItem]!
    init(frame: CGRect, strings: [String]) {
        super.init(frame: frame)
        
        for i in 0...strings.count-1 {
            keyFeatureItems[i].setTexts(strings[i])
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}