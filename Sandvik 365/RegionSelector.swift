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
        
    }
    @IBAction func closeAction(sender: AnyObject) {
    }
}