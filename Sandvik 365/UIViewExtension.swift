//
//  File.swift
//  AirThis
//
//  Created by Oskar Hakansson on 15/12/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func fillConstraints(_ toView: UIView) -> [NSLayoutConstraint] {
        let topConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: toView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: toView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: toView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let trailConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: toView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        return [topConstraint, bottomConstraint, trailConstraint, leadingConstraint]
    }
    
    func fillConstraints(_ toView: UIView, topBottomConstant: CGFloat, leadConstant: CGFloat, trailConstant: CGFloat) -> [NSLayoutConstraint] {
        let topConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: toView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: topBottomConstant)
        let bottomConstraint = NSLayoutConstraint(item: toView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: topBottomConstant)
        let leadingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: toView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: leadConstant)
        let trailConstraint = NSLayoutConstraint(item: toView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: trailConstant)
        return [topConstraint, bottomConstraint, leadingConstraint, trailConstraint]
    }
    
    
    func fillConstraints(_ topBottomView: UIView, leadingView: UIView, trailingView: UIView, topBottomConstant: CGFloat, leadConstant: CGFloat, trailConstant: CGFloat) -> [NSLayoutConstraint] {
        let topConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: topBottomView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: topBottomConstant)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: topBottomView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: topBottomConstant)
        let leadingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: leadingView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: leadConstant)
        let trailConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: trailingView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: trailConstant)
        return [topConstraint, bottomConstraint, leadingConstraint, trailConstraint]
    }

}
