//
//  RoiRockDrillDetailView.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 24/09/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation
import UIKit
import NibDesignable

class RoiTopCenterDetailView: NibDesignable {
    
    @IBOutlet weak var extraCost: UILabel!
    @IBOutlet weak var serviceCost: UILabel!
    @IBOutlet weak var prodCost: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var timeSavedLabel: UILabel!
    
    init(frame: CGRect, input: ROITopCenterInput) {
        super.init(frame: frame)
        
        let fmt = NSNumberFormatter()
        extraCost.text = fmt.formatToUSD(input.savedBitCost())
        serviceCost.text = fmt.formatToUSD(input.savedGrindingCost())
        prodCost.text = fmt.formatToUSD(input.savedValueCost())
        timeSavedLabel.text = String(Int(round(input.timeSavedCost()))) + "h"
        totalLabel.text = fmt.formatToUSD(input.maxTotal())
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
