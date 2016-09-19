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
    var progressTimer: Timer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addCircleLayer()
    }
    
    fileprivate func addCircleLayer() {
        circlePathLayer.removeFromSuperlayer()
        circlePathLayer.frame = numberLabel.bounds
        circlePathLayer.lineWidth = 2
        circlePathLayer.fillColor = UIColor.clear.cgColor
        circlePathLayer.strokeColor = Theme.orangePrimaryColor.cgColor
        circlePathLayer.path = UIBezierPath(ovalIn: circlePathLayer.frame).cgPath
        circlePathLayer.transform = CATransform3DMakeRotation(CGFloat(-90.0 / 180.0 * M_PI), 0.0, 0.0, 1.0);
        numberLabel.layer.addSublayer(circlePathLayer)
    }
    
    func startLoadingAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 2.0
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        
        self.circlePathLayer.add(animation, forKey: "strokeEnd")
        
        self.progressTimer = Timer.scheduledTimer(timeInterval: 1.0 / 60.0, target: self, selector:#selector(updateLabel), userInfo: nil, repeats: true)
    }
    
    override func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.progressTimer?.invalidate()
        let delayTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.numberLabel.isHidden = true
            self.circlePathLayer.isHidden = true
            self.logoImageView.isHidden = false
            let newdelayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: newdelayTime) {
                self.removeFromSuperview()
            }
        }
    }
    
    func updateLabel() {
        if let presentationLayer = self.circlePathLayer.presentation() as? CAShapeLayer {
            numberLabel.text = Int64(round(365.0 * presentationLayer.strokeEnd)).description
        }
    }
}
