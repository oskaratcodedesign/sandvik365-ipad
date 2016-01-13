//
//  RegionSelector.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 13/01/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import Foundation
import NibDesignable

protocol RegionSelectorDelegate {
    func didSelectRegion()
}

class RegionSelector : NibDesignable {
    @IBOutlet weak var mapView: UIImageView!
    var colorCodingLookUp: ColorCodingLookup!
   
    
    init(){
        super.init(frame: CGRectZero)
        self.colorCodingLookUp = ColorCodingLookup(imageName: "world-map-colors")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func mapTapAction(sender: UITapGestureRecognizer) {
        let point = sender.locationInView(self.mapView)
        // notrh [UIColor colorWithRed:1.000 green:0.400 blue:0.000 alpha:1.000]
        //south [UIColor colorWithRed:0.400 green:0.000 blue:0.000 alpha:1.000]
        //europe [UIColor colorWithRed:0.000 green:0.400 blue:0.400 alpha:1.000]
        //af [UIColor colorWithRed:0.000 green:0.400 blue:1.000 alpha:1.000]
        //as [UIColor colorWithRed:1.000 green:0.000 blue:0.400 alpha:1.000]
        // aus [UIColor colorWithRed:0.000 green:1.000 blue:0.400 alpha:1.000]
        let color = self.colorCodingLookUp.colorForPoint(point)
        print(color)
        
    }
    @IBAction func closeAction(sender: AnyObject) {
        self.removeFromSuperview()
    }
}