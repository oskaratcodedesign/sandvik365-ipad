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
        
        let currentServices = input.services
        input.services = [.RampUp]
        let rt = input.total()
        rampUpLabel.text = "$" + String(rt);
        input.services = [.ConditionInspection]
        let ct = input.total()
        conditionLabel.text = "$" + String(ct);
        input.services = [.MaintenancePlanning]
        let mt = input.total() - ct
        maintenanceLabel.text = "$" + String(mt);
        input.services = currentServices
        
        totalLabel.text = "$" + String(rt + ct + mt);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}