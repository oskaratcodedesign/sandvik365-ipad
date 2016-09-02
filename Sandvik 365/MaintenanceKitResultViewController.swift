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
    var amount: Int
    
    init(maintenanceServiceKitParent: MaintenanceServiceKitParent, amount: Int){
        self.maintenanceServiceKitParent = maintenanceServiceKitParent
        self.amount = amount
    }
}

class MaintenanceKitResultViewController: UIViewController, ContactUsViewDelegate, RegionSelectorDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var contactUsView: ContactUsView!
    @IBOutlet weak var tableView: UITableView!
    
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maintenanceOfferData.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MaintenanceTableViewCell") as! MaintenanceTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.configureView(self.maintenanceOfferData[indexPath.row])
        return cell
    }
    
    private func setData() {
        if let alldata = MaintenanceServiceKitData.getAllData(), let input = self.addedExtraEquipmentData {
            self.maintenanceOfferData = [MaintenanceOfferData]()
            for obj in input {
                if obj.workingConditionExtreme, let id = obj.serviceKitData.H125ServiceKitNo {
                    let amount = obj.hours / 125
                    addMaintenanceKit(alldata, id: id, amount: amount)
                }
                if let id = obj.serviceKitData.H250ServiceKitNo {
                    let amount = obj.hours / 250
                    addMaintenanceKit(alldata, id: id, amount: amount)
                }
                if let id = obj.serviceKitData.H500ServiceKitNo {
                    let amount = obj.hours / 500
                    addMaintenanceKit(alldata, id: id, amount: amount)
                }
                if let id = obj.serviceKitData.H1000ServiceKitNo {
                    let amount = obj.hours / 1000
                    addMaintenanceKit(alldata, id: id, amount: amount)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    private func addMaintenanceKit(allData: [String: MaintenanceServiceKitParent], id: String, amount: Int) {
        if let data = allData[id] {
            self.maintenanceOfferData.append(MaintenanceOfferData(maintenanceServiceKitParent: data, amount: amount))
        }
    }
}
