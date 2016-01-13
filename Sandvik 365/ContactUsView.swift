//
//  ContactUsView.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 12/01/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import Foundation
import NibDesignable

protocol ContactUsViewDelegate {
    func showRegionAction()
}

class ContactUsView : NibDesignable, RegionSelectorDelegate {
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    
    var delegate: ContactUsViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.didSelectRegion()
    }
    
    @IBAction func phoneAction(sender: AnyObject) {
    }
    @IBAction func emailAction(sender: AnyObject) {
    }
    @IBAction func visitAction(sender: AnyObject) {
    }
    @IBAction func showRegionAction(sender: AnyObject) {
        self.delegate?.showRegionAction()
    }
    
    func didSelectRegion() {
        let region = Region.selectedRegion
        self.mapImageView.image = region.smallMap
    }
}