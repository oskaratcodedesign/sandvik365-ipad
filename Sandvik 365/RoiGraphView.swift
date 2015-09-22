//
//  RoiGraphView.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 20/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit

class RoiGraphView: UIView {

    @IBOutlet weak var yGraph: UIView!
    @IBOutlet weak var xGraph: UIView!
    @IBOutlet weak var graphView: UIView!
    
    var selectedROIInput: ROIInput! {
        didSet {
            drawGraphs()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        addYInterValLines()
        addXInterValLines()
        drawGraphs()
    }
    
    /*func setSelectedService(set: Bool, service: ROIService)
    {
        if set {
            selectedROICalculator.services.insert(service)
        }
        else {
            selectedROICalculator.services.remove(service)
        }
        drawGraphs()
    }*/
    
    private func drawGraphs() {
        
        for view in graphView.subviews {
            view.removeFromSuperview()
        }
        drawGraph(selectedROIInput.calculatedTotal(), color: UIColor(red: 0.890, green:0.431, blue:0.153, alpha:1.000))
        drawGraph(selectedROIInput.originalTotal(), color: UIColor(red: 0.082, green:0.678, blue:0.929, alpha:1.000))
    }
    
    private func drawGraph(values: [UInt], color: UIColor)
    {
        let xSpace = xGraph.bounds.size.width / CGFloat(values.count)
        let height = graphView.bounds.size.height
        let yPValue = height / CGFloat(selectedROIInput.total())
        
        let path = UIBezierPath()
        var x = xSpace
        
        path.moveToPoint(CGPointMake(0, height))
        for value in values {
            let y = height - CGFloat(value) * yPValue
            path.addLineToPoint(CGPointMake(x, y))
            x += xSpace
        }
        path.addLineToPoint(CGPointMake(x-xSpace, height))
        path.closePath()
        let shapeLAyer = CAShapeLayer()
        shapeLAyer.path = path.CGPath
        shapeLAyer.fillColor = color.CGColor
        let view = UIView()
        view.layer.addSublayer(shapeLAyer)
        graphView.addSubview(view)
        
    }
    

    private func addYInterValLines() {
        for view in yGraph.subviews {
            view.removeFromSuperview()
        }
        let height = yGraph.bounds.size.height
        let space = height*0.2
        var y = space
        while y < height-2 {
            let imageView = UIImageView(frame: CGRectMake(-10, y, 10, 2))
            imageView.backgroundColor = UIColor.whiteColor()
            yGraph.addSubview(imageView)
            y += space
        }
    }
    
    private func addXInterValLines() {
        for view in xGraph.subviews {
            view.removeFromSuperview()
        }
        let lenght = xGraph.bounds.size.width
        let space = lenght*0.1
        var x = space
        while x < lenght-2 {
            let imageView = UIImageView(frame: CGRectMake(x, 0, 2, 10))
            imageView.backgroundColor = UIColor.whiteColor()
            xGraph.addSubview(imageView)
            x += space
        }
    }
}
