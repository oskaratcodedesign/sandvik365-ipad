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
    func showRegionAction(regionData: RegionData?)
}

class ContactUsView : NibDesignable, RegionSelectorDelegate {
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    
    var delegate: ContactUsViewDelegate?
    private var selectedRegionData: RegionData?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.didSelectRegion(nil)
    }
    
    @IBAction func phoneAction(sender: AnyObject) {
        if var phone = self.selectedRegionData?.contactCountry?.phone {
            phone = phone.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "0123456789-+()").invertedSet).joinWithSeparator("")
            if let url = NSURL(string: "tel://\(phone)") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    @IBAction func emailAction(sender: AnyObject) {
        if let email = self.selectedRegionData?.contactCountry?.email {
            if let url = NSURL(string: "mailto://\(email)") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    @IBAction func visitAction(sender: AnyObject) {
        if let url = self.selectedRegionData?.contactCountry?.url {
            if let url = NSURL(string: url) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    @IBAction func showRegionAction(sender: AnyObject) {
        self.delegate?.showRegionAction(self.selectedRegionData)
    }
    
    func didSelectRegion(regionData: RegionData?) {
        let region = Region.selectedRegion
        self.mapImageView.image = region.smallMap
        if let regionData = regionData != nil ? regionData : region.regionData {
            self.regionLabel.text = regionData.contactCountry?.name
            self.phoneButton.setTitle(regionData.contactCountry?.phone, forState: .Normal)
            self.selectedRegionData = regionData
        }
    }
}