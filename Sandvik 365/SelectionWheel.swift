//
//  SelectionWheel.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 19/10/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import UIKit

class SelectionWheel: UIView {

    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var wheelContainer: UIView!
    var sectionPoints: [CGPoint] = []
    var sectionLayers: [CAShapeLayer] = []
    var currentSection = 3
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        let recognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
        centerLabel.userInteractionEnabled = true
        centerLabel.addGestureRecognizer(recognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //remove in case they exist
        if let sublayers = wheelContainer.layer.sublayers {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
        if let sublayers = centerLabel.layer.sublayers {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }
        
        let frame = centerLabel.layer.frame
        centerLabel.layer.roundCALayer(frame, fill: false, color: UIColor(red: 0.890, green:0.431, blue:0.153, alpha:1.000))
        centerLabel.layer.addSublayer(CALayer().roundCALayer(CGRectMake(2, 2, frame.size.width-4, frame.size.height-4), fill: false, color: UIColor(red: 0.890, green:0.431, blue:0.153, alpha:1.000))!)
        drawWheel()
        //rotate(false)
        setCurrentSelection(1)
        //	float angleVal = (((atan2((endPoint.x - startPoint.x) , (endPoint.y - startPoint.y)))*180)/M_PI);
    }
    
    func handleTap(recognizer: UIGestureRecognizer) {
        rotate(true)
    }
    
    private func rotate(animate: Bool) {
        let currentPoint = sectionPoints[currentSection]
        let nextSection = currentSection + 1 < sectionLayers.count ? currentSection + 1 : 0
        let nextPoint = sectionPoints[nextSection]
        
        /*currentPoint = CGPointApplyAffineTransform(currentPoint, self.wheelContainer.transform)
        currentPoint = CGPointMake(currentPoint.x + centerLabel.center.x, currentPoint.y + centerLabel.center.y)
        nextPoint = CGPointApplyAffineTransform(nextPoint, self.wheelContainer.transform)
        nextPoint = CGPointMake(nextPoint.x + centerLabel.center.x, nextPoint.y + centerLabel.center.y)*/
        
        let angle = atan2(nextPoint.y - currentPoint.y, nextPoint.x - currentPoint.x)
        print(angle, currentPoint, nextPoint)
        
        if animate {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.wheelContainer.transform = CGAffineTransformMakeRotation(-angle)
                
                }) { (Bool) -> Void in
                    self.setCurrentSelection(nextSection)
            }
        }
        else {
            self.wheelContainer.transform = CGAffineTransformMakeRotation(-angle)
            self.setCurrentSelection(nextSection)
        }
    }
    
    private func setCurrentSelection(section: Int) {
        
        self.currentSection = section
        let prevSection = currentSection-1 >= 0 ? currentSection-1 : sectionLayers.count-1
        sectionLayers[prevSection].fillColor = UIColor.clearColor().CGColor
        
        sectionLayers[currentSection].fillColor = UIColor(red: 0.890, green:0.431, blue:0.153, alpha:1.000).CGColor
    }
    
    private func drawWheel() {
        
        let path = UIBezierPath()
        
        let height = self.wheelContainer.bounds.size.height
        let width = self.wheelContainer.bounds.size.width
        //create sections
        path.moveToPoint(CGPointMake(0, height/2))
        
        addSection(path, nextPoint: CGPointMake(width/5, height-height/1.2))
        //2
        addSection(path, nextPoint: CGPointMake(width/2, 0))
        //3
        addSection(path, nextPoint: CGPointMake(width/1.3, height-height/1.2))
        //4
        addSection(path, nextPoint: CGPointMake(width, height/2))
        //5
        addSection(path, nextPoint: CGPointMake(width/1.3, height/1.2))
        //6
        addSection(path, nextPoint: CGPointMake(width/2, height))
        //7
        addSection(path, nextPoint: CGPointMake(width/5, height/1.2))
        //8
        addSection(path, nextPoint: CGPointMake(0, height/2))
        path.closePath()
        
        let shapeLAyer = CAShapeLayer()
        shapeLAyer.path = path.CGPath
        shapeLAyer.lineWidth = 2
        shapeLAyer.fillColor = UIColor(white: 0, alpha: 0.5).CGColor
        shapeLAyer.strokeColor = UIColor(red: 0.890, green:0.431, blue:0.153, alpha:1.000).CGColor
        wheelContainer.layer.insertSublayer(shapeLAyer, atIndex: 0)
    }
    
    private func addSection(path: UIBezierPath, nextPoint: CGPoint) {
        
        let center = centerLabel.center
        let sectionPath = UIBezierPath()
        sectionPath.moveToPoint(path.currentPoint)
        sectionPath.addLineToPoint(center)
        sectionPath.addLineToPoint(nextPoint)
        
        let xDiff = nextPoint.x - path.currentPoint.x
        let yDiff = nextPoint.y - path.currentPoint.y
        
        let angle = atan2(yDiff, xDiff)
        let distance = sqrt((xDiff * xDiff) + (yDiff * yDiff))
        
        //var label = UILabel(frame: CGRectMake(0, 10, distance, 50))
        let label = CATextLayer()
        label.frame = CGRectMake(path.currentPoint.x, path.currentPoint.y, distance, 50)
        label.string = "this and that"
        label.font = UIFont(name: "AktivGroteskCorpMedium-Regular", size: 20)
        label.fontSize = 20
        label.anchorPoint = CGPointMake(0, 0)
        label.transform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
        label.position = path.currentPoint
        label.alignmentMode = kCAAlignmentCenter
        sectionPoints.append(nextPoint)
        
        let shapeLAyer = CAShapeLayer()
        shapeLAyer.path = sectionPath.CGPath
        shapeLAyer.fillColor = UIColor.clearColor().CGColor
        
        shapeLAyer.addSublayer(label)
        sectionLayers.append(shapeLAyer)
        wheelContainer.layer.addSublayer(shapeLAyer)
        
        path.addLineToPoint(nextPoint)
    }
}
