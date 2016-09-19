//
//  ExtraEquipmentViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 31/08/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


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
    fileprivate var maintenanceServiceKitData: [String: MaintenanceServiceKitParent]?
    
    var addedExtraEquipmentData = [ExtraEquipmentData]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.maintenanceServiceKitData = MaintenanceServiceKitData.getAllData()
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleMainTap))
        self.view.addGestureRecognizer(tap)
    }
    
    func handleMainTap() {
        self.view.endEditing(true)
    }
    
    fileprivate func setData() {

        var tempData = [ExtraEquipmentData]()
        for obj in self.addedServiceKitData! {
            if let index = self.addedExtraEquipmentData.index(where: {obj.serialNo == $0.serviceKitData.serialNo}) {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedExtraEquipmentData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    fileprivate func findServiceKit(_ obj: ExtraEquipmentData) -> Bool {
        if let id = obj.serviceKitData.H1000ServiceKit?.pno , !id.isEmpty {
            if findIdInData(id) {
                return true
            }
        }
        if let id = obj.serviceKitData.H500ServiceKit?.pno , !id.isEmpty {
            if findIdInData(id) {
                return true
            }
        }
        if let id = obj.serviceKitData.H250ServiceKit?.pno , !id.isEmpty {
            if findIdInData(id) {
                return true
            }
        }
        if obj.workingConditionExtreme, let id = obj.serviceKitData.H125ServiceKit?.pno , !id.isEmpty {
            if findIdInData(id) {
                return true
            }
        }
        return false
    }
    
    fileprivate func findIdInData(_ id: String) -> Bool {
        if let data = self.maintenanceServiceKitData {
            if data[id] != nil {
                return true
            }
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = self.addedExtraEquipmentData[(indexPath as NSIndexPath).row]
        if findServiceKit(data) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EqExtraCell") as! EqExtraTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.configureView(data)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EqExtraNoKitCell") as! EqExtraNoKitTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.configureView(data)
            return cell
        }
    }
    
    func getAllCellData() -> [ExtraEquipmentData]? {
        if self.addedServiceKitData?.count > 0 {
            var extraData = [ExtraEquipmentData]()
            for (index, value) in self.addedServiceKitData!.enumerated() {
                if let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 1)) as? EqExtraTableViewCell {
                    let data = ExtraEquipmentData(serviceKitData: value, hours: Int(cell.hours.text ?? "0")!, workingConditionExtreme: cell.workingCondition.selectedSegmentIndex == 0 ? false : true)
                    extraData.append(data)
                }
            }
            return extraData
        }
        return nil
    }
    
    func keyboardWillShow(_ notification: Notification) {
        let info : NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height + 60, 0.0)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        self.tableView.contentInset = UIEdgeInsets.zero
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
