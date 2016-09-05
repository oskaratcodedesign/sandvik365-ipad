
//
//  EqExtraTableViewCell.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 31/08/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import Foundation

class EqExtraTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var hours: UITextField!
    @IBOutlet weak var serialNo: UILabel!
    @IBOutlet weak var model: UILabel!
    @IBOutlet weak var workingCondition: UISegmentedControl!
    private var data: ExtraEquipmentData?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.hours.delegate = self
    }
    
    func configureView(data: ExtraEquipmentData){
        self.serialNo.text = data.serviceKitData.serialNo
        self.model.text = data.serviceKitData.model ?? ""
        self.hours.text = String(data.hours)
        self.workingCondition.selectedSegmentIndex = data.workingConditionExtreme ? 1 : 0
        self.data = data
    }
    
    @IBAction func increaseHoursAction(sender: UIButton) {
        if var v = (hours.text != nil) ? Int(hours.text!) : 0 {
            v = v + 125
            self.data?.hours = v
            hours.text = String(v)
        }
    }
    
    @IBAction func decreaseHoursAction(sender: UIButton) {
        if var v = (hours.text != nil) ? Int(hours.text!) : 0 {
            v = v - 125
            v = max(v, 0)
            self.data?.hours = v
            hours.text = String(v)
        }
    }
    
    @IBAction func workingConditionChanged(sender: UISegmentedControl) {
        self.data?.workingConditionExtreme = sender.selectedSegmentIndex == 0 ? false : true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let no = (hours.text != nil) ? Int(hours.text! + string) : 0 {
            self.data?.hours = no
            return true
        }
        return false
    }
}