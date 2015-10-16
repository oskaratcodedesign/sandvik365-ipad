//
//  MainMenuItemView.swift
//  Sandvik 365
//
//  Created by Karl Söderström on 06/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation
import UIKit
import NibDesignable

class MainMenuItemView : NibDesignable {
    let focusZoomLevel: CGFloat = 1.2
    let unfocusZoomLevel: CGFloat = 1.0
    var partType: PartType!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    @IBInspectable var title: String? = nil {
        didSet {
            self.label.text = title
        }
    }
    
    @IBInspectable var image: UIImage? = nil {
        didSet {
            self.button.imageView?.contentMode = .ScaleAspectFill
            self.button.setImage(image, forState: .Normal)
        }
    }
    
    @IBInspectable var partBridgeType: NSNumber! {
        didSet {
            self.partType = PartType(rawValue: partBridgeType.unsignedLongValue)
        }
    }
    
    func updateZoomLevel() {
        if let scrollView = self.superview as? UIScrollView {
            let midScrollView = scrollView.frame.width / 2
            
            // midpoint on the actual screen
            let midPoint = self.frame.midX - scrollView.contentOffset.x
            
            // offset from center
            let offset = abs(midScrollView - midPoint)
            
            // inverse it
            let inverseOffset = midScrollView - offset
            
            // calc scale between unfocusZoomLevel and focusZoomLevel
            let scale = self.unfocusZoomLevel + (self.focusZoomLevel - self.unfocusZoomLevel) * easeInOut(max(inverseOffset, 0) / midScrollView)
            
            self.button.transform = CGAffineTransformMakeScale(scale, scale)
        }
    }
    
    // Modeled after the piecewise quadratic
    // y = (1/2)((2x)^2)             ; [0, 0.5)
    // y = -(1/2)((2x-1)*(2x-3) - 1) ; [0.5, 1]
    func easeInOut(value: CGFloat) -> CGFloat {
        if value < 0.5 {
            return 2 * value * value
        } else {
            return (-2 * value * value) + (4 * value) - 1
        }
    }
}