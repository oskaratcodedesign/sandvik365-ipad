//
//  RoiCrusherDetailView.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 24/09/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation
import UIKit
import NibDesignable

class RoiCrusherDetailView: NibDesignable {

    @IBOutlet weak var rampUpLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var maintenanceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    init(frame: CGRect, input: ROICrusherInput) {
        super.init(frame: frame)
        
        /*let fmt = NSNumberFormatter()
        fmt.numberStyle = .DecimalStyle
        
        let currentServices = input.services
        input.services = [.RampUp]
        let rt = input.total()
        rampUpLabel.text = "$" + fmt.stringFromNumber(rt)!
        input.services = [.ConditionInspection]
        let ct = input.total()
        conditionLabel.text = "$" + fmt.stringFromNumber(ct)!
        input.services = [.MaintenancePlanning]
        let mt = input.total() - ct
        maintenanceLabel.text = "$" + fmt.stringFromNumber(mt)!
        input.services = currentServices
        
        totalLabel.text = "$" + fmt.stringFromNumber(rt + ct + mt)!*/
    }

    @IBAction func closeAction(sender: AnyObject) {
        if let superview = self.superview {
            self.removeFromSuperview()
            superview.hidden = true
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}