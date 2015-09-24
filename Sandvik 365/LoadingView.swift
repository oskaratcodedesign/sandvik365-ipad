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
    
    @IBOutlet weak var numberLabel: UILabel!
    let circlePathLayer = CAShapeLayer()
    var progressTimer: NSTimer?
    var progress: UInt = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addCircleLayer()
    }
    
    private func addCircleLayer() {
        circlePathLayer.removeFromSuperlayer()
        circlePathLayer.frame = numberLabel.bounds
        circlePathLayer.lineWidth = 2
        circlePathLayer.fillColor = UIColor.clearColor().CGColor
        circlePathLayer.strokeColor = UIColor(red: 0.890, green:0.431, blue:0.153, alpha:1.000).CGColor
        circlePathLayer.path = UIBezierPath(ovalInRect: circlePathLayer.frame).CGPath
        circlePathLayer.transform = CATransform3DMakeRotation(CGFloat(-90.0 / 180.0 * M_PI), 0.0, 0.0, 1.0);
        circlePathLayer.strokeEnd = 0
        numberLabel.layer.addSublayer(circlePathLayer)
        
        /*let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 1
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        circlePathLayer.addAnimation(pathAnimation, forKey: "test")*/
    }
    
    func startLoadingAnimation() {
        if progressTimer != nil {
            progressTimer!.invalidate()
            progressTimer = nil
        }
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.progressTimer = NSTimer.scheduledTimerWithTimeInterval(2.0/365, target: self, selector: Selector("animateProgress"), userInfo: nil, repeats: true)
        }
    }
    
    func animateProgress() {
        if (progress > 365) {
            setStrokeEnd(1)
            progressTimer?.invalidate()
            progressTimer = nil
            let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.removeFromSuperview()
            }
            return
        } else if (progress < 0) {
            setStrokeEnd(0)
        } else {
            setStrokeEnd(CGFloat(progress)/365)
        }
        numberLabel.text = self.progress.description
        progress++
        
    }
    
    private func setStrokeEnd(value: CGFloat)
    {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        circlePathLayer.strokeEnd = value
        CATransaction.commit()
    }
}