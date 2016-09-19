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
    
    fileprivate func addDisclaimerButtonPath() {
        let view = showContainer
        if let sublayers = view?.layer.sublayers?.flatMap({ $0 as? CAShapeLayer}) {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
        
        let frame = view?.frame
        let sectionPath = UIBezierPath()
        sectionPath.move(to: CGPoint(x: 0, y: (frame?.size.height)!))
        sectionPath.addLine(to: CGPoint(x: 0, y: 0))
        sectionPath.addLine(to: CGPoint(x: (frame?.width)!-5, y: 4))
        sectionPath.addLine(to: CGPoint(x: (frame?.width)!, y: (frame?.size.height)!))
        sectionPath.close()
        let shapeLAyer = CAShapeLayer()
        shapeLAyer.path = sectionPath.cgPath
        shapeLAyer.fillColor = Theme.orangePrimaryColor.cgColor
        view?.layer.insertSublayer(shapeLAyer, at: 0)
    }
    
    fileprivate func addCloseButtonPath() {
        let view = disclaimerContainer
        if let sublayers = view?.layer.sublayers?.flatMap({ $0 as? CAShapeLayer}) {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
        
        let frame = view?.frame
        let sectionPath = UIBezierPath()
        sectionPath.move(to: CGPoint(x: 0, y: (frame?.size.height)!))
        sectionPath.addLine(to: CGPoint(x: 0, y: (frame?.size.height)!/5))
        sectionPath.addLine(to: CGPoint(x: (frame?.width)!-(frame?.width)!/2.5, y: 0))
        sectionPath.addLine(to: CGPoint(x: (frame?.width)!-50, y: (frame?.size.height)!/6))
        sectionPath.addLine(to: CGPoint(x: (frame?.width)!, y: (frame?.size.height)!-(frame?.size.height)!/3))
        sectionPath.addLine(to: CGPoint(x: (frame?.width)!, y: (frame?.size.height)!))
        sectionPath.close()
        let shapeLAyer = CAShapeLayer()
        shapeLAyer.path = sectionPath.cgPath
        shapeLAyer.fillColor = Theme.orangePrimaryColor.cgColor
        view?.layer.insertSublayer(shapeLAyer, at: 0)
    }
    
    override func layoutSubviews() {
        addCloseButtonPath()
        addDisclaimerButtonPath()
    }
    
    @IBAction func showDisclaimerAction(_ sender: UIButton) {
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.disclaimerContainer.isHidden = false
    }
    @IBAction func closeDisclaimerAction(_ sender: AnyObject) {
        self.backgroundColor = UIColor.clear
        self.disclaimerContainer.isHidden = true
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self.showButton || view == self.closeButton {
            return view
        }
        else if !self.disclaimerContainer.isHidden {
            return self.disclaimerContainer
        }
        return nil
    }
}
