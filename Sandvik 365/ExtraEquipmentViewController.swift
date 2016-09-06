//
//  ExtraEquipmentViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 31/08/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import UIKit

class ExtraEquipmentData {
    var serviceKitData: ServiceKitData
    var hours: Int
    var workingConditionExtreme: Bool
    
    init(serviceKitData: ServiceKitData, hours: Int, workingConditionExtreme: Bool){
        self.serviceKitData = serviceKitData
        self.hours = hours
        self.workingConditionExtreme = workingConditionExtreme
    }
}

class ExtraEquipmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var addedServiceKitData: [ServiceKitData]? {
        didSet {
            setData()
        }
    }
    private var maintenanceServiceKitData: [String: MaintenanceServiceKitParent]?
    
    var addedExtraEquipmentData = [ExtraEquipmentData]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.maintenanceServiceKitData = MaintenanceServiceKitData.getAllData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleMainTap))
        self.view.addGestureRecognizer(tap)
    }
    
    func handleMainTap() {
        self.view.endEditing(true)
    }
    
    private func setData() {

        var tempData = [ExtraEquipmentData]()
        for obj in self.addedServiceKitData! {
            if let index = self.addedExtraEquipmentData.indexOf({obj.serialNo == $0.serviceKitData.serialNo}) {
                tempData.append(self.addedExtraEquipmentData[index])
            } else {
                //default
                tempData.append(ExtraEquipmentData(serviceKitData: obj, hours: 0, workingConditionExtreme: false))
            }
        }
        self.addedExtraEquipmentData = tempData
        if let table = self.tableView {
            table.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedExtraEquipmentData.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    private func findServiceKit(obj: ExtraEquipmentData) -> Bool {
        if let id = obj.serviceKitData.H1000ServiceKitNo where !id.isEmpty {
            if findIdInData(id) {
                return true
            }
        }
        if let id = obj.serviceKitData.H500ServiceKitNo where !id.isEmpty {
            if findIdInData(id) {
                return true
            }
        }
        if let id = obj.serviceKitData.H250ServiceKitNo where !id.isEmpty {
            if findIdInData(id) {
                return true
            }
        }
        if obj.workingConditionExtreme, let id = obj.serviceKitData.H125ServiceKitNo where !id.isEmpty {
            if findIdInData(id) {
                return true
            }
        }
        return false
    }
    
    private func findIdInData(id: String) -> Bool {
        if let data = self.maintenanceServiceKitData {
            if data[id] != nil {
                return true
            }
        }
        return false
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let data = self.addedExtraEquipmentData[indexPath.row]
        if findServiceKit(data) {
            let cell = tableView.dequeueReusableCellWithIdentifier("EqExtraCell") as! EqExtraTableViewCell
            cell.backgroundColor = UIColor.clearColor()
            cell.configureView(data)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("EqExtraNoKitCell") as! EqExtraNoKitTableViewCell
            cell.backgroundColor = UIColor.clearColor()
            cell.configureView(data)
            return cell
        }
    }
    
    func getAllCellData() -> [ExtraEquipmentData]? {
        if self.addedServiceKitData?.count > 0 {
            var extraData = [ExtraEquipmentData]()
            for (index, value) in self.addedServiceKitData!.enumerate() {
                if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 1)) as? EqExtraTableViewCell {
                    let data = ExtraEquipmentData(serviceKitData: value, hours: Int(cell.hours.text ?? "0")!, workingConditionExtreme: cell.workingCondition.selectedSegmentIndex == 0 ? false : true)
                    extraData.append(data)
                }
            }
            return extraData
        }
        return nil
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height + 60, 0.0)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.tableView.contentInset = UIEdgeInsetsZero
    }

}
