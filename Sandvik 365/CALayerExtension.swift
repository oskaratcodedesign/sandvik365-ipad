//
//  UIImage.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 19/10/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    
    func roundCALayer(frame: CGRect, fill: Bool, color: UIColor) -> CALayer? {
        self.frame = frame
        self.cornerRadius = frame.size.width/2
        self.masksToBounds = true
        if fill {
            self.backgroundColor = color.CGColor
        }
        else {
            self.borderWidth = 1
            self.borderColor = color.CGColor
        }
        return self
    }
    
    func roundImage(frame: CGRect, fill: Bool, color: UIColor) -> UIImage? {
        roundCALayer(frame, fill: fill, color: color)
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0);
        self.renderInContext(UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return roundedImage
    }
    
}
