//
//  NSLayoutConstraintExtension.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 22/12/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    
    func changeMultiplier(_ multiplier:CGFloat) -> NSLayoutConstraint {
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        NSLayoutConstraint.deactivate([self])
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
    }
    
    func newMultiplier(_ multiplier:CGFloat) -> NSLayoutConstraint {
    
        let newConstraint = NSLayoutConstraint(
        item: firstItem,
        attribute: firstAttribute,
        relatedBy: relation,
        toItem: secondItem,
        attribute: secondAttribute,
        multiplier: multiplier,
        constant: constant)
        
        return newConstraint
    }
}
