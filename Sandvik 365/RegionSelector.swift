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
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var regionLabel: UILabel!
    var colorCodingLookUp: ColorCodingLookup!
    var delegate: RegionSelectorDelegate?
    fileprivate var selectedRegionData: RegionData?
    fileprivate var allRegions: [RegionData]!
    
    init(del: RegionSelectorDelegate, allRegions: [RegionData]){
        super.init(frame: CGRect.zero)
        self.colorCodingLookUp = ColorCodingLookup(imageName: "world-map-colors")
        self.delegate = del
        self.allRegions = allRegions
        setRegionData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setRegionData() {
        let region = Region.selectedRegion(self.allRegions)
        self.mapView.image = region.bigMap
        if let regionData = region.getRegionData(self.allRegions) {
            self.regionLabel.text = regionData.contactCountry?.name
            self.phoneButton.setTitle(regionData.contactCountry?.phone, for: UIControlState())
            self.selectedRegionData = regionData
        }
    }
    
    @IBAction func mapTapAction(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self.mapView)
        if let color = self.colorCodingLookUp.color(for: point) {
            if let region = Region.allRegions.filter({ color.isEqual($0.color) }).first {
                region.setSelectedRegion()
                setRegionData()
            }
        }
        
    }
    @IBAction func closeAction(_ sender: AnyObject) {
        self.delegate?.didSelectRegion()
    }
    
    @IBAction func phoneAction(_ sender: AnyObject) {
        if var phone = self.selectedRegionData?.contactCountry?.phone {
            phone = phone.components(separatedBy: CharacterSet(charactersIn: "0123456789-+()").inverted).joined(separator: "")
            if let url = URL(string: "tel://\(phone)") {
                UIApplication.shared.openURL(url)
            }
        }
    }
    @IBAction func emailAction(_ sender: AnyObject) {
        if let email = self.selectedRegionData?.contactCountry?.email {
            if let url = URL(string: "mailto://\(email)") {
                UIApplication.shared.openURL(url)
            }
        }
    }
    @IBAction func visitAction(_ sender: AnyObject) {
        if let url = self.selectedRegionData?.contactCountry?.url {
            if let url = URL(string: url) {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
