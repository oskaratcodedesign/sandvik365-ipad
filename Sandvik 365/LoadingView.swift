//
//  LoadingView.swift
//  Sandvik 365
//
//  Created by Karl Söderström on 22/07/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation
import UIKit
import NibDesignable


class LoadingView : NibDesignable {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    let circlePathLayer = CAShapeLayer()
    var progressTimer: NSTimer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addCircleLayer()
    }
    
    private func addCircleLayer() {
        circlePathLayer.removeFromSuperlayer()
        circlePathLayer.frame = numberLabel.bounds
        circlePathLayer.lineWidth = 2
        circlePathLayer.fillColor = UIColor.clearColor().CGColor
        circlePathLayer.strokeColor = Theme.orangePrimaryColor.CGColor
        circlePathLayer.path = UIBezierPath(ovalInRect: circlePathLayer.frame).CGPath
        circlePathLayer.transform = CATransform3DMakeRotation(CGFloat(-90.0 / 180.0 * M_PI), 0.0, 0.0, 1.0);
        numberLabel.layer.addSublayer(circlePathLayer)
    }
    
    func startLoadingAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 2.0
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        animation.delegate = self
        
        self.circlePathLayer.addAnimation(animation, forKey: "strokeEnd")
        
        self.progressTimer = NSTimer.scheduledTimerWithTimeInterval(1.0 / 60.0, target: self, selector:#selector(updateLabel), userInfo: nil, repeats: true)
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.progressTimer?.invalidate()
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(0.5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.numberLabel.hidden = true
            self.circlePathLayer.hidden = true
            self.logoImageView.hidden = false
            let newdelayTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(newdelayTime, dispatch_get_main_queue()) {
                self.removeFromSuperview()
            }
        }
    }
    
    func updateLabel() {
        if let presentationLayer = self.circlePathLayer.presentationLayer() as? CAShapeLayer {
            numberLabel.text = Int64(round(365.0 * presentationLayer.strokeEnd)).description
        }
    }
}