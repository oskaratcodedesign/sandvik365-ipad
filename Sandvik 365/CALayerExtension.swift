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
    
    func roundCALayer(_ frame: CGRect, fill: Bool, color: UIColor) -> CALayer? {
        self.frame = frame
        self.cornerRadius = frame.size.width/2
        self.masksToBounds = true
        if fill {
            self.backgroundColor = color.cgColor
        }
        else {
            self.borderWidth = 1
            self.borderColor = color.cgColor
        }
        return self
    }
    
    func roundCALayer(_ frame: CGRect, border: CGFloat, color: UIColor) -> CALayer? {
        self.frame = frame
        self.cornerRadius = frame.size.width/2
        self.masksToBounds = true
        self.borderWidth = border
        self.borderColor = color.cgColor
        return self
    }
    
    func roundImage(_ frame: CGRect, fill: Bool, color: UIColor) -> UIImage? {
        roundCALayer(frame, fill: fill, color: color)
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0);
        self.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return roundedImage
    }
    
    func borderUIColor() -> UIColor? {
        return borderColor != nil ? UIColor(cgColor: borderColor!) : nil
    }

    func setBorderUIColor(_ color: UIColor) {
        borderColor = color.cgColor
    }
    
}
