//
//  RoundButton.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 28/12/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import UIKit

@IBDesignable class RoundButton: UIButton {

    @IBInspectable internal var borderColor: UIColor? {
        didSet {
            configure()
        }
    }
    
    @IBInspectable internal var borderHeight: NSNumber? {
        didSet {
            configure()
        }
    }
    
    fileprivate func configure() {
        let height = borderHeight !=  nil ? CGFloat(borderHeight!.floatValue) : self.bounds.size.height
        let color = borderColor ?? UIColor.white
        let borderimage = CALayer().roundImage(CGRect(x: 0, y: 0, width: height, height: height), fill: false, color: color)
        self.setImage(borderimage, for: UIControlState())
        let fillimage = CALayer().roundImage(CGRect(x: 0, y: 0, width: height, height: height), fill: true, color: color)
        self.setImage(fillimage, for: .highlighted)
        self.setImage(fillimage, for: .selected)
    }

}
