//
//  MaintenanceTableViewCell.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 02/09/16.
//  Copyright © 2016 Commind. All rights reserved.
//

class MaintenanceTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var amount: UILabel!
    fileprivate var data: MaintenanceOfferData!
    
    @IBAction func decreaseAmountAction(_ sender: UIButton) {
        if var v = (amount.text != nil) ? Int(amount.text!) : 0 {
            v = v - 1
            data.amount = max(v, 0)
            amount.text = String(data.amount)
        }
    }
    
    @IBAction func increaseAmountAction(_ sender: UIButton) {
        if var v = (amount.text != nil) ? Int(amount.text!) : 0 {
            v = v + 1
            data.amount = v
            amount.text = String(v)
        }
    }
    
    func configureView(_ data: MaintenanceOfferData) {
        self.data = data
        self.name.text = data.description
        self.amount.text = String(data.amount)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            self.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        }
        else {
            self.backgroundColor = UIColor.clear
        }
    }
}
