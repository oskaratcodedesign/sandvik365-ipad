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
    var delegate: RegionSelectorDelegate?
    
    init(del: RegionSelectorDelegate){
        super.init(frame: CGRectZero)
        self.colorCodingLookUp = ColorCodingLookup(imageName: "world-map-colors")
        self.delegate = del
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func mapTapAction(sender: UITapGestureRecognizer) {
        let point = sender.locationInView(self.mapView)

        if let color = self.colorCodingLookUp.colorForPoint(point) {
            if let region = Region.allRegions.filter({ color.isEqual($0.color) }).first {
                self.mapView.image = region.bigMap
                region.setSelectedRegion()
            }
        }
        
    }
    @IBAction func closeAction(sender: AnyObject) {
        self.removeFromSuperview()
        self.delegate?.didSelectRegion()
    }
}