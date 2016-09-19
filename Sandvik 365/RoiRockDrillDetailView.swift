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

class RoiRockDrillDetailView: NibDesignable {
    
    @IBOutlet weak var metersBeforeLabel: UILabel!
    @IBOutlet weak var metersAfterLabel: UILabel!
    @IBOutlet weak var tonnageBeforeLabel: UILabel!
    @IBOutlet weak var tonnageAfterLabel: UILabel!
    @IBOutlet weak var oreOutPutLabel: UILabel!
    @IBOutlet weak var shanksLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    init(frame: CGRect, input: ROIRockDrillInput) {
        super.init(frame: frame)
        
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        
        metersBeforeLabel.text = fmt.string(from: NSNumber(Int(input.metersDrilledYearlyBefore())))! + "m"
        metersAfterLabel.text = fmt.string(from: NSNumber(Int(input.metersDrilledYearlyAfter())))! + "m"
        
        tonnageBeforeLabel.text = fmt.string(from: NSNumber(Int(input.tonnageOutputBefore())))! + "t"
        tonnageAfterLabel.text = fmt.string(from: NSNumber(Int(input.tonnageOutputAfter())))! + "t"
        
        if let total = input.total() {
            let shanksAndBitsSavings = Int(input.shanksAndBitsSavings())
            oreOutPutLabel.text = "$" + fmt.string(from: total - shanksAndBitsSavings)!
            shanksLabel.text = "$" + fmt.string(from: NSNumber(shanksAndBitsSavings))!
            totalLabel.text = "$" + fmt.string(from: NSNumber(total))!
        }
    }
    
    @IBAction func closeAction(_ sender: AnyObject) {
        if let superview = self.superview {
            self.removeFromSuperview()
            superview.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
