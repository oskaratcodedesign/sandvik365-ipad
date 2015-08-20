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
    
    var selectedROICalculator: ROICalculator! {
        didSet {
            drawGraph()
        }
    }
    
    var selectedROISerives: [ROIService]! = [ROIService]()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        addYInterValLines()
        addXInterValLines()
    }
    
    func setSelectedService(set: Bool, service: ROIService)
    {
        if set {
            selectedROISerives.append(service)
        }
        else if let index = find(selectedROISerives, service) {
            selectedROISerives.removeAtIndex(index)
        }
        drawGraph()
    }
    
    private func drawGraph()
    {
        
    }
    

    private func addYInterValLines() {
        for view in yGraph.subviews {
            view.removeFromSuperview()
        }
        let height = yGraph.bounds.size.height
        let space = height*0.2
        var y = space
        while y < height-2 {
            var imageView = UIImageView(frame: CGRectMake(-10, y, 10, 2))
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
            var imageView = UIImageView(frame: CGRectMake(x, 0, 2, 10))
            imageView.backgroundColor = UIColor.whiteColor()
            xGraph.addSubview(imageView)
            x += space
        }
    }
}
