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
    var sectionPoints: [CGPoint]!
    var sectionLayers: [CAShapeLayer]!
    var currentSection = 0
    var sectionTitles: [String]!
    var rotateAnimationRunning: Bool = false
    let numberOfSections = 8
    
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
        setup()
    }
    
    func handleTap(recognizer: UIGestureRecognizer) {
        rotate(true)
    }
    
    private func setup() {
        sectionPoints = []
        sectionLayers = []
        currentSection = 0
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
        rotate(false)
    }
    
    private func rotate(animate: Bool) {
        let currentPoint = sectionPoints[currentSection]
        let nextSection = currentSection + 1 < sectionLayers.count ? currentSection + 1 : 0
        let nextPoint = sectionPoints[nextSection]
        
        let angle = atan2(nextPoint.y - currentPoint.y, nextPoint.x - currentPoint.x)
        print(angle, currentPoint, nextPoint)
        
        if animate {
            if !rotateAnimationRunning {
                self.clearCurrentSelection()
                rotateAnimationRunning = true
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.wheelContainer.transform = CGAffineTransformMakeRotation(-angle)
                    
                    }) { (Bool) -> Void in
                        self.setCurrentSelection(nextSection)
                        self.rotateAnimationRunning = false
                }
            }
        }
        else {
            self.wheelContainer.transform = CGAffineTransformMakeRotation(-angle)
            self.setCurrentSelection(nextSection)
        }
    }
    
    private func clearCurrentSelection() {
        let prevSection = currentSection-1 >= 0 ? currentSection-1 : sectionLayers.count-1
        sectionLayers[prevSection].fillColor = UIColor.clearColor().CGColor
        getTextLayer(prevSection).foregroundColor = UIColor(red: 0.890, green:0.431, blue:0.153, alpha:1.000).CGColor
    }
    
    private func setCurrentSelection(nextSection: Int) {
        sectionLayers[currentSection].fillColor = UIColor(red: 0.890, green:0.431, blue:0.153, alpha:1.000).CGColor
        getTextLayer(currentSection).foregroundColor = UIColor.blackColor().CGColor
        feedSectionTitle()
        currentSection = nextSection
    }
    
    private func feedSectionTitle() {
        let bottomSection = (currentSection + 5) % numberOfSections
        if let label = getTextLayer(bottomSection) {
            let prevBottomSection = (currentSection + 4) % numberOfSections
            if let prevLabel = getTextLayer(prevBottomSection) {
                if let prevTitle = prevLabel.string {
                    let nextTitleIndex = (sectionTitles.indexOf(prevTitle as! String)! + 1) % sectionTitles.count
                    label.string = sectionTitles[nextTitleIndex]
                }
            }
        }
    }
    
    private func drawWheel() {
        let path = UIBezierPath()
        
        let height = self.wheelContainer.bounds.size.height
        let width = self.wheelContainer.bounds.size.width
        //create sections
        path.moveToPoint(CGPointMake(width-width/1.1, height/2))
        
        addSection(path, nextPoint: CGPointMake(width/5, height-height/1.2))
        //2
        addSection(path, nextPoint: CGPointMake(width/2, 0))
        //3
        addSection(path, nextPoint: CGPointMake(width/1.3, height-height/1.2))
        //4
        addSection(path, nextPoint: CGPointMake(width/1.1, height/2))
        //5
        addSection(path, nextPoint: CGPointMake(width/1.3, height/1.2))
        //6
        addSection(path, nextPoint: CGPointMake(width/2, height))
        //7
        addSection(path, nextPoint: CGPointMake(width/5, height/1.2))
        //8
        addSection(path, nextPoint: CGPointMake(width-width/1.1, height/2))
        path.closePath()
        
        let shapeLAyer = CAShapeLayer()
        shapeLAyer.path = path.CGPath
        shapeLAyer.lineWidth = 2
        shapeLAyer.fillColor = UIColor(white: 0, alpha: 0.8).CGColor
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
        
        let container = CALayer()
        container.frame = CGRectMake(path.currentPoint.x, path.currentPoint.y, distance, 50)
        let label = CATextLayer()
        let padding = distance / 8
        label.frame = CGRectMake(padding, 10, distance-padding*2, 50)
        let stringIndex = sectionLayers.count+1 == numberOfSections ? sectionTitles.count-1 : sectionLayers.count % sectionTitles.count
        label.string = sectionTitles[stringIndex]
        label.font = UIFont(name: "AktivGroteskCorpMedium-Regular", size: 20)
        label.fontSize = 20
        label.alignmentMode = kCAAlignmentCenter
        label.wrapped = true
        label.contentsScale = UIScreen.mainScreen().scale
        label.foregroundColor = UIColor(red: 0.890, green:0.431, blue:0.153, alpha:1.000).CGColor
        container.addSublayer(label)
        container.anchorPoint = CGPointMake(0, 0)
        container.transform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
        container.position = path.currentPoint
        
        let x = path.currentPoint.x + (distance/2)*cos(angle)
        let y = path.currentPoint.y + (distance/2)*sin(angle)
        sectionPoints.append(CGPointMake(x, y))
        
        let shapeLAyer = CAShapeLayer()
        shapeLAyer.path = sectionPath.CGPath
        shapeLAyer.fillColor = UIColor.clearColor().CGColor
        
        shapeLAyer.addSublayer(container)
        sectionLayers.append(shapeLAyer)
        wheelContainer.layer.addSublayer(shapeLAyer)
        
        path.addLineToPoint(nextPoint)
    }
    
    private func getTextLayer(section: Int) -> CATextLayer! {
        return sectionLayers[section].sublayers!.first!.sublayers!.first as! CATextLayer
    }
}
