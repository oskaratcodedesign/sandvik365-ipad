//
//  MaintenanceKitResultViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 01/09/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import UIKit

class MaintenanceOfferData {
    let maintenanceServiceKitParent: MaintenanceServiceKitParent
    var hours: Int
    
    init(maintenanceServiceKitParent: MaintenanceServiceKitParent, hours: Int){
        self.maintenanceServiceKitParent = maintenanceServiceKitParent
        self.hours = hours
    }
}

class MaintenanceKitResultViewController: UIViewController, ContactUsViewDelegate, RegionSelectorDelegate {
    
    @IBOutlet weak var contactUsView: ContactUsView!
    
    var addedExtraEquipmentData: [ExtraEquipmentData]? {
        didSet {
            setData()
        }
    }
    private var maintenanceOfferData = [MaintenanceOfferData]()
    private var regionSelector: RegionSelector?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contactUsView.delegate = self
    }
    
    func didSelectRegion() {
        if let regionSelector = self.regionSelector {
            regionSelector.removeFromSuperview()
            self.regionSelector = nil
        }
        self.contactUsView.didSelectRegion()
    }
    
    func showRegionAction(allRegions: [RegionData]) {
        regionSelector = RegionSelector(del: self, allRegions: allRegions)
        let constraints = regionSelector!.fillConstraints(self.view, topBottomConstant: 0, leadConstant: 0, trailConstant: 0)
        regionSelector!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(regionSelector!)
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    private func setData() {
        if let alldata = MaintenanceServiceKitData.getAllData(), let input = self.addedExtraEquipmentData {
            
            for obj in input {
                if obj.workingConditionExtreme, let id = obj.serviceKitData.H125ServiceKitNo {
                    addMaintenanceKit(alldata, id: id, extraEquipmentData: obj)
                }
                if let id = obj.serviceKitData.H250ServiceKitNo {
                    addMaintenanceKit(alldata, id: id, extraEquipmentData: obj)
                }
                if let id = obj.serviceKitData.H500ServiceKitNo {
                    addMaintenanceKit(alldata, id: id, extraEquipmentData: obj)
                }
                if let id = obj.serviceKitData.H1000ServiceKitNo {
                    addMaintenanceKit(alldata, id: id, extraEquipmentData: obj)
                }
            }
        }
    }
    
    private func addMaintenanceKit(allData: [String: MaintenanceServiceKitParent], id: String, extraEquipmentData: ExtraEquipmentData) {
        if let data = allData[id] {
            self.maintenanceOfferData.append(MaintenanceOfferData(maintenanceServiceKitParent: data, hours: extraEquipmentData.hours))
        }
    }
}
