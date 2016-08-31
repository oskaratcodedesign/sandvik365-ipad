//
//  EqExtraTableViewCell.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 31/08/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import Foundation

class EqExtraTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hours: UITextField!
    @IBOutlet weak var serialNo: UILabel!
    @IBOutlet weak var model: UILabel!
    //var delegate: EqStandardCellDelegate?
    @IBOutlet weak var workingCondition: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureView(data: ServiceKitData){
        self.serialNo.text = data.serialNo
        self.model.text = data.model ?? ""
    }
    @IBAction func increaseHoursAction(sender: UIButton) {
    }
    
    @IBAction func decreaseHoursAction(sender: UIButton) {
    }
}