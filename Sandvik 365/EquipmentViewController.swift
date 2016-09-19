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
    fileprivate var serviceKitData: [String: ServiceKitData]?
    fileprivate var regionSelector: RegionSelector?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: EqFoooterView!
    override func viewDidLoad() {
        super.viewDidLoad()
        footerView.configureView(addedServiceKitData.isEmpty)
        footerView.delegate = self
        
        self.serviceKitData = ServiceKitData.getAllData()
        //DEBUG
        /*addedServiceKitData.append(serviceKitData!["L003D636"]!)
        addedServiceKitData.append(serviceKitData!["L203D812"]!)
        addedServiceKitData.append(serviceKitData!["L203E103"]!)
        addedServiceKitData.append(serviceKitData!["L407D619"]!)*/
        
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleMainTap))
        self.view.addGestureRecognizer(tap)
    }
    
    func handleMainTap() {
        self.footerView.enterText.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedServiceKitData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell = tableView.dequeueReusableCell(withIdentifier: "EqStandardCell") as! EqStandardTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.configureView(self.addedServiceKitData[(indexPath as NSIndexPath).row])
        cell.delegate = self
        return cell
    }
    
    func keyboardWillShow(_ notification: Notification) {
        let info : NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height + 60, 0.0)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        self.tableView.contentInset = UIEdgeInsets.zero
    }
    
    func didAddSerialNo(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            for (key, value) in self.serviceKitData! {
                if text.caseInsensitiveCompare(key) == .orderedSame {
                    self.addedServiceKitData.append(value)
                    self.tableView.reloadData()
                    textField.text = ""
                    return true
                }
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
        if let regions = JSONManager.getData(JSONManager.EndPoint.contact_US) as? [RegionData] {
            regionSelector = RegionSelector(del: self, allRegions: regions)
            let constraints = regionSelector!.fillConstraints(self.view, topBottomConstant: 0, leadConstant: 0, trailConstant: 0)
            regionSelector!.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(regionSelector!)
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    func didPressRemove(_ sender: EqStandardTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: sender) {
            self.addedServiceKitData.remove(at: (indexPath as NSIndexPath).row)
            self.tableView.reloadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
