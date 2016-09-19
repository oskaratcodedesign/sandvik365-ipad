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
    init(frame: CGRect, keyFeatureList: Content.KeyFeatureListContent) {
        super.init(frame: frame)
        
        if let texts = keyFeatureList.texts {
            for i in 0...texts.count-1 {
                keyFeatureItems[i].isHidden = false
                keyFeatureItems[i].setTexts(texts[i])
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
