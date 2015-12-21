//
//  Disclaimer.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 21/12/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation
import NibDesignable

class Disclaimer: NibDesignable {

    @IBOutlet weak var disclaimerContainer: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var showContainer: UIView!
    
    private func addDisclaimerButtonPath() {
        let view = showContainer
        if let sublayers = view.layer.sublayers?.flatMap({ $0 as? CAShapeLayer}) {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
        
        let frame = view.frame
        let sectionPath = UIBezierPath()
        sectionPath.moveToPoint(CGPointMake(0, frame.size.height))
        sectionPath.addLineToPoint(CGPointMake(0, 0))
        sectionPath.addLineToPoint(CGPointMake(frame.width-5, 4))
        sectionPath.addLineToPoint(CGPointMake(frame.width, frame.size.height))
        sectionPath.closePath()
        let shapeLAyer = CAShapeLayer()
        shapeLAyer.path = sectionPath.CGPath
        shapeLAyer.fillColor = UIColor(red: 0.890, green:0.431, blue:0.153, alpha:1.000).CGColor
        view.layer.insertSublayer(shapeLAyer, atIndex: 0)
    }
    
    private func addCloseButtonPath() {
        let view = disclaimerContainer
        if let sublayers = view.layer.sublayers?.flatMap({ $0 as? CAShapeLayer}) {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
        
        let frame = view.frame
        let sectionPath = UIBezierPath()
        sectionPath.moveToPoint(CGPointMake(0, frame.size.height))
        sectionPath.addLineToPoint(CGPointMake(0, frame.size.height/5))
        sectionPath.addLineToPoint(CGPointMake(frame.width-frame.width/2.5, 0))
        sectionPath.addLineToPoint(CGPointMake(frame.width-50, frame.size.height/6))
        sectionPath.addLineToPoint(CGPointMake(frame.width, frame.size.height-frame.size.height/3))
        sectionPath.addLineToPoint(CGPointMake(frame.width, frame.size.height))
        sectionPath.closePath()
        let shapeLAyer = CAShapeLayer()
        shapeLAyer.path = sectionPath.CGPath
        shapeLAyer.fillColor = UIColor(red: 0.890, green:0.431, blue:0.153, alpha:1.000).CGColor
        view.layer.insertSublayer(shapeLAyer, atIndex: 0)
    }
    
    override func layoutSubviews() {
        addCloseButtonPath()
        addDisclaimerButtonPath()
    }
    
    @IBAction func showDisclaimerAction(sender: UIButton) {
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.disclaimerContainer.hidden = false
    }
    @IBAction func closeDisclaimerAction(sender: AnyObject) {
        self.backgroundColor = UIColor.clearColor()
        self.disclaimerContainer.hidden = true
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, withEvent: event)
        if view == self.showButton || view == self.closeButton {
            return view
        }
        else if !self.disclaimerContainer.hidden {
            return self.disclaimerContainer
        }
        return nil
    }
}