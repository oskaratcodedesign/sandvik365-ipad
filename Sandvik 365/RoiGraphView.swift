//
//  RoiGraphView.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 20/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class RoiGraphView: UIView {
    
    @IBOutlet weak var yGraph: UIView!
    @IBOutlet weak var xGraph: UIView!
    @IBOutlet weak var graphView: UIView!
    
    var selectedROIInput: ROICalculatorInput! {
        didSet {
            drawGraphs()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        //addYInterValLines()
        //addXInterValLines()
        drawGraphs()
    }
    
    fileprivate func drawGraphs() {
        
        for view in graphView.subviews {
            view.removeFromSuperview()
        }
        drawGraph(selectedROIInput.calculatedTotal(), color: Theme.orangePrimaryColor)
        drawGraph(selectedROIInput.originalTotal(), color: Theme.bluePrimaryColor)
    }
    
    fileprivate func drawGraph(_ values: [Int], color: UIColor)
    {
        if values.isEmpty {
            return
        }
        
        let xSpace = xGraph.bounds.size.width / CGFloat(values.count)
        let height = graphView.bounds.size.height
        let yPValue = height / selectedROIInput.graphScale() / CGFloat(selectedROIInput.maxTotal())
        
        let path = UIBezierPath()
        var x = xSpace
        
        if values.first > 0 {
            //straight
            x = 0
        }
        path.move(to: CGPoint(x: 0, y: height))
        for value in values {
            if value >= 0 {
                let y = value == 0 ? height : height / selectedROIInput.graphScale() - (CGFloat(value) * yPValue)
                path.addLine(to: CGPoint(x: x, y: y))
            }
            else {
                path.move(to: CGPoint(x: x+xSpace, y: height))//move forward so we can produce a straight line once value is changed
            }
            x += xSpace
        }
        path.addLine(to: CGPoint(x: x-xSpace, y: height))
        path.close()
        let shapeLAyer = CAShapeLayer()
        shapeLAyer.path = path.cgPath
        shapeLAyer.fillColor = color.cgColor
        let view = UIView()
        view.layer.addSublayer(shapeLAyer)
        graphView.addSubview(view)
        
    }
    
    
    fileprivate func addYInterValLines() {
        for view in yGraph.subviews {
            view.removeFromSuperview()
        }
        let height = yGraph.bounds.size.height
        let space = height*0.2
        var y = space
        while y < height-2 {
            let imageView = UIImageView(frame: CGRect(x: -10, y: y, width: 10, height: 2))
            imageView.backgroundColor = UIColor.white
            yGraph.addSubview(imageView)
            y += space
        }
    }
    
    fileprivate func addXInterValLines() {
        for view in xGraph.subviews {
            view.removeFromSuperview()
        }
        let lenght = xGraph.bounds.size.width
        let space = lenght*0.1
        var x = space
        while x < lenght-2 {
            let imageView = UIImageView(frame: CGRect(x: x, y: 0, width: 2, height: 10))
            imageView.backgroundColor = UIColor.white
            xGraph.addSubview(imageView)
            x += space
        }
    }
}
