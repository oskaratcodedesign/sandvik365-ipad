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

class RoiEDVDetailView: NibDesignable {
    
    @IBOutlet weak var extraCost: UILabel!
    @IBOutlet weak var serviceCost: UILabel!
    @IBOutlet weak var prodCost: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    init(frame: CGRect, input: ROIEDVInput) {
        super.init(frame: frame)
        
        let fmt = NSNumberFormatter()
        extraCost.text = fmt.formatToUSD(input.totalExtraCost())
        serviceCost.text = fmt.formatToUSD(input.totalServiceCostPerBreakDown())
        prodCost.text = fmt.formatToUSD(input.totalProductivityLoss())
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
