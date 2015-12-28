//
//  RoundButton.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 28/12/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import UIKit

@IBDesignable class RoundButton: UIButton {

    @IBInspectable internal var borderColor: UIColor! {
        didSet {
            var size = self.bounds.size
            size.width = size.height
            let borderimage = CALayer().roundImage(CGRectMake(0, 0, size.width, size.height), fill: false, color: borderColor)
            self.setImage(borderimage, forState: .Normal)
            let fillimage = CALayer().roundImage(CGRectMake(0, 0, size.width, size.height), fill: true, color: borderColor)
            self.setImage(fillimage, forState: .Highlighted)
            self.setImage(fillimage, forState: .Selected)
        }
    }

}
