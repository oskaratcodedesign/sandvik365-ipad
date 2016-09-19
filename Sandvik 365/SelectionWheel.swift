//
//  SelectionWheel.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 19/10/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import UIKit

protocol SelectionWheelDelegate {
    func didSelectSection(_ sectionTitle: String)
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
        centerLabel.isUserInteractionEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    fileprivate func setup() {
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
        centerLabel.layer.addSublayer(CALayer().roundCALayer(CGRect(x: 4, y: 4, width: frame.size.width-8, height: frame.size.height-8), border: 2, color: Theme.orangePrimaryColor)!)
        drawWheel()
    }
    
    fileprivate func setCurrentSelection(_ nextSection: Int) {
        feedSectionTitle()
        currentSection = nextSection
    }
    
    fileprivate func feedSectionTitle() {
        let bottomSection = (currentSection + 5) % numberOfSections
        if let label = getTextLayer(bottomSection) {
            let prevBottomSection = (currentSection + 4) % numberOfSections
            if let prevLabel = getTextLayer(prevBottomSection) {
                if let prevTitle = prevLabel.string {
                    let nextTitleIndex = (sectionTitles.index(of: prevTitle as! String)! + 1) % sectionTitles.count
                    label.string = sectionTitles[nextTitleIndex]
                }
            }
        }
    }
    
    fileprivate func drawWheel() {
        let path = UIBezierPath()
        
        let height = self.wheelContainer.bounds.size.height
        let width = self.wheelContainer.bounds.size.width
        //create sections
        path.move(to: CGPoint(x: width-width/1.1, y: height/2))
        
        addSection(path, nextPoint: CGPoint(x: width/5, y: height-height/1.2))
        //2
        addSection(path, nextPoint: CGPoint(x: width/2, y: 0))
        //3
        addSection(path, nextPoint: CGPoint(x: width/1.3, y: height-height/1.2))
        //4
        addSection(path, nextPoint: CGPoint(x: width/1.1, y: height/2))
        //5
        addSection(path, nextPoint: CGPoint(x: width/1.3, y: height/1.2))
        //6
        addSection(path, nextPoint: CGPoint(x: width/2, y: height))
        //7
        addSection(path, nextPoint: CGPoint(x: width/5, y: height/1.2))
        //8
        addSection(path, nextPoint: CGPoint(x: width-width/1.1, y: height/2))
        path.close()
        
        let shapeLAyer = CAShapeLayer()
        shapeLAyer.path = path.cgPath
        shapeLAyer.lineWidth = 2
        shapeLAyer.fillColor = UIColor(white: 0, alpha: 0.8).cgColor
        shapeLAyer.strokeColor = Theme.orangePrimaryColor.cgColor
        wheelContainer.layer.insertSublayer(shapeLAyer, at: 0)
    }
    
    fileprivate func addSection(_ path: UIBezierPath, nextPoint: CGPoint) {
        
        let center = centerLabel.center
        let sectionPath = UIBezierPath()
        sectionPath.move(to: path.currentPoint)
        sectionPath.addLine(to: center)
        sectionPath.addLine(to: nextPoint)
        
        let xDiff = nextPoint.x - path.currentPoint.x
        let yDiff = nextPoint.y - path.currentPoint.y
        
        let angle = atan2(yDiff, xDiff)
        let distance = sqrt((xDiff * xDiff) + (yDiff * yDiff))
        
        let container = CALayer()
        container.frame = CGRect(x: path.currentPoint.x, y: path.currentPoint.y, width: distance, height: 50)
        let label = CATextLayer()
        let padding = distance / 8
        label.frame = CGRect(x: padding, y: 10, width: distance-padding*2, height: 100)
        let stringIndex = sectionLayers.count+1 == numberOfSections ? sectionTitles.count-1 : sectionLayers.count % sectionTitles.count
        label.string = sectionTitles[stringIndex]
        label.font = UIFont(name: "AktivGroteskCorpMedium-Regular", size: 20)
        label.fontSize = 16
        label.alignmentMode = kCAAlignmentCenter
        label.isWrapped = true
        label.contentsScale = UIScreen.main.scale
        label.foregroundColor = Theme.orangePrimaryColor.cgColor
        
        container.addSublayer(label)
        container.anchorPoint = CGPoint(x: 0, y: 0)
        container.transform = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0)
        container.position = path.currentPoint
        
        let x = path.currentPoint.x + (distance/2)*cos(angle)
        let y = path.currentPoint.y + (distance/2)*sin(angle)
        sectionPoints.append(CGPoint(x: x, y: y))
        
        let shapeLAyer = CAShapeLayer()
        shapeLAyer.path = sectionPath.cgPath
        shapeLAyer.fillColor = UIColor.clear.cgColor
        
        let mask = CAShapeLayer()
        let p = UIBezierPath(rect: self.bounds)
        p.append(UIBezierPath(roundedRect: centerLabel.frame, cornerRadius: centerLabel.frame.size.width/2))
        //sectionPath.usesEvenOddFillRule = true
        mask.path = p.cgPath
        mask.fillRule = kCAFillRuleEvenOdd;
        shapeLAyer.mask = mask
        shapeLAyer.addSublayer(container)
        sectionLayers.append(shapeLAyer)
        wheelContainer.layer.addSublayer(shapeLAyer)
        
        path.addLine(to: nextPoint)
    }
    
    fileprivate func getTextLayer(_ section: Int) -> CATextLayer! {
        return getTextLayer(sectionLayers[section])
    }
    
    fileprivate func getTextLayer(_ layer: CAShapeLayer) -> CATextLayer! {
        return layer.sublayers!.first!.sublayers!.first as! CATextLayer
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            // 1 - Get touch position
            let pt = touch.location(in: self)
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
                    let p = touch.location(in: wheelContainer)
                    
                    for layer in sectionLayers {
                        if CGPathContainsPoint(layer.path,
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        clearTouchedLayer()
        
        let touch = touches.first
        let pt = touch!.location(in: self)
        let dx = pt.x  - wheelContainer.center.x
        let dy = pt.y  - wheelContainer.center.y
        let ang = atan2(dy,dx)
        let angleDifference = deltaAngle! - ang
        wheelContainer.transform = startTransform!.rotated(by: -angleDifference)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchedLayer != nil, let touch = touches.first, let delegate = self.delegate {
            fillTouchedLayer()
            if let layer = touchedLayer as? CAShapeLayer{
                if CGPathContainsPoint(layer.path,
                    nil, touch.location(in: wheelContainer), false) {
                        if let title = getTextLayer(layer).string as? String {
                            delegate.didSelectSection(title)
                        }
                }
            }
        }
        clearTouchedLayer()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        clearTouchedLayer()
    }
    
    fileprivate func fillTouchedLayer() {
        if touchedLayer != nil {
            if let layer = touchedLayer as? CAShapeLayer{
                layer.fillColor = Theme.orangePrimaryColor.cgColor
                getTextLayer(layer).foregroundColor = UIColor.black.cgColor
            }
        }
    }
    
    fileprivate func clearTouchedLayer() {
        if touchedLayer != nil {
            if let layer = touchedLayer as? CAShapeLayer{
                layer.fillColor = UIColor.clear.cgColor
                getTextLayer(layer).foregroundColor = Theme.orangePrimaryColor.cgColor
            }
            touchedLayer = nil
        }
    }
}
