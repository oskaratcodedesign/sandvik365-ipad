//
//  EqFoooterTableViewCell.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 29/08/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import UIKit

protocol EqStandardCellDelegate {
    func didPressRemove(sender: EqStandardTableViewCell)
}

class EqStandardTableViewCell: UITableViewCell {

    @IBOutlet weak var serialNo: UILabel!
    @IBOutlet weak var model: UILabel!
    var delegate: EqStandardCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureView(data: ServiceKitData){
        self.serialNo.text = data.serialNo
        self.model.text = data.model ?? ""
    }

    @IBAction func removeAction(sender: UIButton) {
        self.delegate?.didPressRemove(self)
    }
}
