//
//  EqFoooterTableViewCell.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 29/08/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import UIKit

class EqFoooterTableViewCell: UITableViewCell {

    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var enterView: UIView!
    @IBOutlet weak var enterText: UITextField!
    
    @IBOutlet weak var openButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        enterText.attributedPlaceholder = NSAttributedString(string:"Enter here",attributes:[NSForegroundColorAttributeName: Theme.bluePrimaryColor])
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureView(showEnterView: Bool){
        self.addView.hidden = showEnterView
        self.enterView.hidden = !showEnterView
    }

    @IBAction func closeAction(sender: UIButton) {
        self.addView.hidden = false
        self.enterView.hidden = true
    }
    
    @IBAction func openAction(sender: UIButton) {
        self.addView.hidden = true
        self.enterView.hidden = false
    }
    @IBAction func addAction(sender: UIButton) {
        self.addView.hidden = false
        self.enterView.hidden = true
    }
}
