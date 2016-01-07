//
//  HighlightButton.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 07/01/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import UIKit

@IBDesignable class HighlightButton: UIButton {

    @IBInspectable internal var highlightBgColor: UIColor?
    @IBInspectable internal var bgColor: UIColor?
    
    override var highlighted: Bool {
        didSet {
            if highlighted {
                self.backgroundColor = highlightBgColor
            } else {
                self.backgroundColor = bgColor
            }
        }
    }

}
