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
    func didSelectRegion(regionData: RegionData?)
}

class RegionSelector : NibDesignable {
    @IBOutlet weak var mapView: UIImageView!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var regionLabel: UILabel!
    var colorCodingLookUp: ColorCodingLookup!
    var delegate: RegionSelectorDelegate?
    private var selectedRegionData: RegionData?
    
    init(del: RegionSelectorDelegate, regionData: RegionData?){
        super.init(frame: CGRectZero)
        self.colorCodingLookUp = ColorCodingLookup(imageName: "world-map-colors")
        self.delegate = del
        setRegionData(regionData)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRegionData(regionData: RegionData?) {
        let region = Region.selectedRegion
        self.mapView.image = region.bigMap
        if let regionData = regionData != nil ? regionData : region.regionData {
            self.regionLabel.text = regionData.contactCountry?.name
            self.phoneButton.setTitle(regionData.contactCountry?.phone, forState: .Normal)
            self.selectedRegionData = regionData
        }
    }
    
    @IBAction func mapTapAction(sender: UITapGestureRecognizer) {
        let point = sender.locationInView(self.mapView)

        if let color = self.colorCodingLookUp.colorForPoint(point) {
            if let region = Region.allRegions.filter({ color.isEqual($0.color) }).first {
                self.mapView.image = region.bigMap
                region.setSelectedRegion()
                setRegionData(region.regionData)
            }
        }
        
    }
    @IBAction func closeAction(sender: AnyObject) {
        self.removeFromSuperview()
        self.delegate?.didSelectRegion(self.selectedRegionData)
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
}