//
//  SelectionWheel.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 19/10/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import UIKit

protocol SelectionWheelDelegate {
    func didSelectSection(sectionTitle: String)
}

class SelectionWheel: UIView {

    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var wheelContainer: UIView!
    var sectionPoints: [CGPoint]!
    var sectionLayers: [CAShapeLayer]!
    var currentSection = 0
    var sectionTitles: [String]!
    var rotateAnimationRunning: Bool = false
    var touchedLayer: CALayer?
    let numberOfSections = 8
    
    var startTransform: CGAffineTransform?
    var deltaAngle: CGFloat?
    
    var delegate: SelectionWheelDelegate?
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        centerLabel.userInteractionEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
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
        centerLabel.layer.roundCALayer(frame, border: 2, color: Theme.orangePrimaryColor)
        centerLabel.layer.addSublayer(CALayer().roundCALayer(CGRectMake(4, 4, frame.size.width-8, frame.size.height-8), border: 2, color: Theme.orangePrimaryColor)!)
        drawWheel()
    }
    
    private func setCurrentSelection(nextSection: Int) {
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
        shapeLAyer.strokeColor = Theme.orangePrimaryColor.CGColor
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
        label.frame = CGRectMake(padding, 10, distance-padding*2, 100)
        let stringIndex = sectionLayers.count+1 == numberOfSections ? sectionTitles.count-1 : sectionLayers.count % sectionTitles.count
        label.string = sectionTitles[stringIndex]
        label.font = UIFont(name: "AktivGroteskCorpMedium-Regular", size: 20)
        label.fontSize = 16
        label.alignmentMode = kCAAlignmentCenter
        label.wrapped = true
        label.contentsScale = UIScreen.mainScreen().scale
        label.foregroundColor = Theme.orangePrimaryColor.CGColor
        
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
        
        let mask = CAShapeLayer()
        let p = UIBezierPath(rect: self.bounds)
        p.appendPath(UIBezierPath(roundedRect: centerLabel.frame, cornerRadius: centerLabel.frame.size.width/2))
        //sectionPath.usesEvenOddFillRule = true
        mask.path = p.CGPath
        mask.fillRule = kCAFillRuleEvenOdd;
        shapeLAyer.mask = mask
        shapeLAyer.addSublayer(container)
        sectionLayers.append(shapeLAyer)
        wheelContainer.layer.addSublayer(shapeLAyer)
        
        path.addLineToPoint(nextPoint)
    }
    
    private func getTextLayer(section: Int) -> CATextLayer! {
        return getTextLayer(sectionLayers[section])
    }
    
    private func getTextLayer(layer: CAShapeLayer) -> CATextLayer! {
        return layer.sublayers!.first!.sublayers!.first as! CATextLayer
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            // 1 - Get touch position
            let pt = touch.locationInView(self)
            // 2 - Calculate distance from center
            let dx = pt.x  - wheelContainer.center.x
            let dy = pt.y  - wheelContainer.center.y
            // 3 - Calculate arctangent value
            deltaAngle = atan2(dy,dx)
            // 4 - Save current transform
            startTransform = wheelContainer.transform
            if let view = touch.view {
                if view == centerLabel {
                    touchedLayer = centerLabel.layer
                }
                else if view == wheelContainer {
                    let p = touch.locationInView(wheelContainer)
                    
                    for layer in sectionLayers {
                        if CGPathContainsPoint(layer.path!,
                            nil, p, false) {
                            touchedLayer = layer
                            break
                        }
                    }
                }
                fillTouchedLayer()
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        clearTouchedLayer()
        
        let touch = touches.first
        let pt = touch!.locationInView(self)
        let dx = pt.x  - wheelContainer.center.x
        let dy = pt.y  - wheelContainer.center.y
        let ang = atan2(dy,dx)
        let angleDifference = deltaAngle! - ang
        wheelContainer.transform = CGAffineTransformRotate(startTransform!, -angleDifference)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touchedLayer != nil, let touch = touches.first, let delegate = self.delegate {
            fillTouchedLayer()
            if let layer = touchedLayer as? CAShapeLayer{
                if CGPathContainsPoint(layer.path!,
                    nil, touch.locationInView(wheelContainer), false) {
                        if let title = getTextLayer(layer).string as? String {
                            delegate.didSelectSection(title)
                        }
                }
            }
        }
        clearTouchedLayer()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        clearTouchedLayer()
    }
    
    private func fillTouchedLayer() {
        if touchedLayer != nil {
            if let layer = touchedLayer as? CAShapeLayer{
                layer.fillColor = Theme.orangePrimaryColor.CGColor
                getTextLayer(layer).foregroundColor = UIColor.blackColor().CGColor
            }
        }
    }
    
    private func clearTouchedLayer() {
        if touchedLayer != nil {
            if let layer = touchedLayer as? CAShapeLayer{
                layer.fillColor = UIColor.clearColor().CGColor
                getTextLayer(layer).foregroundColor = Theme.orangePrimaryColor.CGColor
            }
            touchedLayer = nil
        }
    }
}
