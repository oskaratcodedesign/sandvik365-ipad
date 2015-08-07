//
//  ProgressLineView.swift
//  Sandvik 365
//
//  Created by Karl Söderström on 07/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation
import UIKit
import NibDesignable

class ProgressLineView : NibDesignable {
    @IBOutlet weak var line : UIView!
    @IBOutlet weak var circle : UIView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    @IBInspectable var color: UIColor? {
        didSet {
            line.backgroundColor = color
            circle.layer.borderColor = color?.CGColor
        }
    }
    
    @IBInspectable var progress: CGFloat = 0.0 {
        didSet {
            leadingConstraint.constant = min(1.0, max(0.0, progress)) * (frame.width - circle.frame.width)
        }
    }
}