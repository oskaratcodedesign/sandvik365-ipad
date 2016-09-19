//
//  ContactUsView.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 12/01/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import Foundation
import NibDesignable

extension ContactUsViewDelegate {
    func didPressEmail(_ email: String) -> Bool {
        return false
    }
}

protocol ContactUsViewDelegate {
    func showRegionAction(_ allRegions: [RegionData])
    func didPressEmail(_ email: String) -> Bool
}

class ContactUsView : NibDesignable {
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    
    var delegate: ContactUsViewDelegate?
    fileprivate var allRegions: [RegionData]?
    fileprivate var selectedRegionData: RegionData?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.allRegions = JSONManager.getData(JSONManager.EndPoint.contact_US) as? [RegionData]
        self.didSelectRegion()
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
            if let del = self.delegate , del.didPressEmail(email) {
                //del was handled
            }
            else if let url = URL(string: "mailto://\(email)") {
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
    @IBAction func showRegionAction(_ sender: AnyObject) {
        if let allRegions = self.allRegions {
            self.delegate?.showRegionAction(allRegions)
        }
    }
    
    func didSelectRegion() {
        if let allRegions = self.allRegions {
            let region = Region.selectedRegion(allRegions)
            self.mapImageView.image = region.smallMap
            if let regionData = region.getRegionData(allRegions) {
                self.regionLabel.text = regionData.contactCountry?.name
                self.phoneButton.setTitle(regionData.contactCountry?.phone, for: UIControlState())
                self.selectedRegionData = regionData
            }
        }
    }
}
