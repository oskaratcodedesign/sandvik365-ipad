//
//  EquipmentViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 29/08/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import UIKit

class EquipmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EqFoooterDelegate, EqStandardCellDelegate, RegionSelectorDelegate {
    var addedServiceKitData = [ServiceKitData]()
    private var serviceKitData: [String: ServiceKitData]?
    private var regionSelector: RegionSelector?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: EqFoooterView!
    override func viewDidLoad() {
        super.viewDidLoad()
        footerView.configureView(addedServiceKitData.isEmpty)
        footerView.delegate = self
        
        self.serviceKitData = ServiceKitData.getAllData()
        //DEBUG
        addedServiceKitData.append(serviceKitData!["L003D636"]!)
        addedServiceKitData.append(serviceKitData!["L203D812"]!)
        addedServiceKitData.append(serviceKitData!["L203E103"]!)
        addedServiceKitData.append(serviceKitData!["L407D619"]!)
        addedServiceKitData.append(serviceKitData!["L003D636"]!)
        addedServiceKitData.append(serviceKitData!["L003D636"]!)
        addedServiceKitData.append(serviceKitData!["L003D636"]!)
        addedServiceKitData.append(serviceKitData!["L003D636"]!)
        addedServiceKitData.append(serviceKitData!["L003D636"]!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedServiceKitData.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let  cell = tableView.dequeueReusableCellWithIdentifier("EqStandardCell") as! EqStandardTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        cell.configureView(self.addedServiceKitData[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height + 60, 0.0)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.tableView.contentInset = UIEdgeInsetsZero
    }
    
    func didAddSerialNo(textField: UITextField) -> Bool {
        if let text = textField.text {
            if let obj = self.serviceKitData![text] {
                self.addedServiceKitData.append(obj)
                self.tableView.reloadData()
                textField.text = ""
                return true
            }
        }
        return false
    }
    
    func didSelectRegion() {
        if let regionSelector = self.regionSelector {
            regionSelector.removeFromSuperview()
            self.regionSelector = nil
        }
    }
    
    func getSupport() {
        if let regions = JSONManager.getData(JSONManager.EndPoint.CONTACT_US) as? [RegionData] {
            regionSelector = RegionSelector(del: self, allRegions: regions)
            let constraints = regionSelector!.fillConstraints(self.view, topBottomConstant: 0, leadConstant: 0, trailConstant: 0)
            regionSelector!.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(regionSelector!)
            NSLayoutConstraint.activateConstraints(constraints)
        }
    }
    
    func didPressRemove(sender: EqStandardTableViewCell) {
        if let indexPath = self.tableView.indexPathForCell(sender) {
            self.addedServiceKitData.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
        }
    }
    
}
