//
//  MaintenanceKitResultViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 01/09/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import UIKit
import MessageUI

class MaintenanceOfferData {
    let maintenanceServiceKitParent: MaintenanceServiceKitParent
    let description: String
    var amount: Int
    
    init(maintenanceServiceKitParent: MaintenanceServiceKitParent, amount: Int, desc: String){
        self.maintenanceServiceKitParent = maintenanceServiceKitParent
        self.amount = amount
        self.description = desc
    }
}

class MaintenanceKitResultViewController: UIViewController, ContactUsViewDelegate, RegionSelectorDelegate, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var contactUsView: ContactUsView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoView: MaintenanceKitInfoView!
    
    var addedExtraEquipmentData: [ExtraEquipmentData]? {
        didSet {
            setData()
        }
    }
    fileprivate var maintenanceOfferData = [MaintenanceOfferData]()
    fileprivate var regionSelector: RegionSelector?
    
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
    
    func showRegionAction(_ allRegions: [RegionData]) {
        regionSelector = RegionSelector(del: self, allRegions: allRegions)
        let constraints = regionSelector!.fillConstraints(self.view, topBottomConstant: 0, leadConstant: 0, trailConstant: 0)
        regionSelector!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(regionSelector!)
        NSLayoutConstraint.activate(constraints)
    }
    
    func didPressEmail(_ email: String) -> Bool {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setSubject("Maintenance Kits Request – 365 APP")
        mail.setToRecipients([email])
        var html = "<!DOCTYPE html>"
        html = html + "<html>"
        html = html + "<body>"
/*  html = html + "<table><tr><td>My name is: </td><td><input type='text' name='name' placeholder='Please enter your name here'></td></tr>"
 html = html + "<br><tr><td>I work at : </td><td><input type='text' name='work' placeholder='Please enter your company here'></td></tr>"
 html = html + "<br><tr><td>Reach me at: </td><td><input type='text' name='phone' placeholder='Please enter your phone number and verify your e-mail address here'></td></tr></table>"*/
        html = html + "Thank you for using our Maintenance kits tool, please enter your contact information below and send the request. We will gladly come back to your shortly. Please note that you will need to have internet connection to send the request."
        html = html + "<br><br>My name is:"
        html = html + "<br>I work at :"
        html = html + "<br>Reach me at:"
        html = html + "<br><br>--- MACHINES & REQUESTED KITS ---<br>"
        html = html + "<br>Kits Part number and quantity:<br>"
        html = html + "<table style='border: 1px solid black; border-collapse: collapse;'>"
        html = html + "<tr style='border: 1px solid black;' bgcolor='#000'>"
        html = html + "<td style='padding-right: 30px;'><b><font color='#fff'>KIT NUMBER</font></b></td><td style='padding-right: 30px;'><b><font color='#fff'>KIT DESCRIPTION</font></b></td><td><b><font color='#fff'>KIT QUANTITY</font></b></td>"
        html = html + "</tr>"
        for data in self.maintenanceOfferData {
            html = html + "<tr style='border: 1px solid black;'><td style='padding-right: 30px;'><b>"
            html = html + data.maintenanceServiceKitParent.serialNo + "</b></td><td style='padding-right: 30px;'>" + data.description + "</td><td>" + String(data.amount) + " KITS</td>"
            html = html + "</tr>"
        }
        html = html + "</table><br>"
        
        if let addedExtraEquipmentData = self.addedExtraEquipmentData {
            html = html + "Machine(s), serial number(s) and hours:<br>"
            html = html + "<ul>"
            for data in addedExtraEquipmentData {
                html = html + "<li>"
                html = html + (data.serviceKitData.model ?? "") + " " + data.serviceKitData.serialNo + " " + String(data.hours) + "h"
                html = html + "</li>"
            }
            html = html + "</ul>"
        }
        
        html = html + "</body>"
        html = html + "</html>"
        mail.setMessageBody(html, isHTML: true)
        self.present(mail, animated: true, completion: nil)
        return true
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maintenanceOfferData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaintenanceTableViewCell") as! MaintenanceTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.configureView(self.maintenanceOfferData[(indexPath as NSIndexPath).row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        self.infoView.data = maintenanceOfferData[(indexPath as NSIndexPath).row]
        self.infoView.isHidden = false
    }
    
    fileprivate func setData() {
        if let alldata = MaintenanceServiceKitData.getAllData(), let input = self.addedExtraEquipmentData {
            self.maintenanceOfferData = [MaintenanceOfferData]()
            for obj in input {
                var alreadyCountedService = 0
                if let dic = obj.serviceKitData.H1000ServiceKit {
                    let amount = obj.hours / 1000
                    alreadyCountedService = amount
                    addMaintenanceKit(alldata, dic: dic, amount: amount)
                }
                
                if let dic = obj.serviceKitData.H500ServiceKit {
                    let amount = obj.hours / 500
                    addMaintenanceKit(alldata, dic: dic, amount: amount-alreadyCountedService)
                    alreadyCountedService = amount
                }
                if let dic = obj.serviceKitData.H250ServiceKit {
                    let amount = obj.hours / 250
                    addMaintenanceKit(alldata, dic: dic, amount: amount-alreadyCountedService)
                    alreadyCountedService = amount
                }
                if obj.workingConditionExtreme, let dic = obj.serviceKitData.H125ServiceKit {
                    let amount = obj.hours / 125
                    addMaintenanceKit(alldata, dic: dic, amount: amount-alreadyCountedService)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    fileprivate func addMaintenanceKit(_ allData: [String: MaintenanceServiceKitParent], dic: (pno: String, description: String), amount: Int) {
        if let data = allData[dic.pno] {
            if let index = self.maintenanceOfferData.index(where: {$0.maintenanceServiceKitParent.serialNo == dic.pno}) {
                //already added
                let data = self.maintenanceOfferData[index]
                data.amount += amount
            } else {
                self.maintenanceOfferData.append(MaintenanceOfferData(maintenanceServiceKitParent: data, amount: max(0, amount), desc: dic.description))
            }
        }
    }
}
