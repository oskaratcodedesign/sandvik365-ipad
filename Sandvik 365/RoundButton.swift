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
    
    private func configure() {
        let height = borderHeight !=  nil ? CGFloat(borderHeight!.floatValue) : self.bounds.size.height
        let color = borderColor ?? UIColor.whiteColor()
        let borderimage = CALayer().roundImage(CGRectMake(0, 0, height, height), fill: false, color: color)
        self.setImage(borderimage, forState: .Normal)
        let fillimage = CALayer().roundImage(CGRectMake(0, 0, height, height), fill: true, color: color)
        self.setImage(fillimage, forState: .Highlighted)
        self.setImage(fillimage, forState: .Selected)
    }

}
