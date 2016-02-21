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
    
    func fillConstraints(toView: UIView) -> [NSLayoutConstraint] {
        let topConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        let trailConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        return [topConstraint, bottomConstraint, trailConstraint, leadingConstraint]
    }
    
    func fillConstraints(toView: UIView, topBottomConstant: CGFloat, leadConstant: CGFloat, trailConstant: CGFloat) -> [NSLayoutConstraint] {
        let topConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: topBottomConstant)
        let bottomConstraint = NSLayoutConstraint(item: toView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: topBottomConstant)
        let leadingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: leadConstant)
        let trailConstraint = NSLayoutConstraint(item: toView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: trailConstant)
        return [topConstraint, bottomConstraint, leadingConstraint, trailConstraint]
    }
    
    
    func fillConstraints(topBottomView: UIView, leadingView: UIView, trailingView: UIView, topBottomConstant: CGFloat, leadConstant: CGFloat, trailConstant: CGFloat) -> [NSLayoutConstraint] {
        let topConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: topBottomView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: topBottomConstant)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: topBottomView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: topBottomConstant)
        let leadingConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: leadingView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: leadConstant)
        let trailConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: trailingView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: trailConstant)
        return [topConstraint, bottomConstraint, leadingConstraint, trailConstraint]
    }

}