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
        
        let fmt = NSNumberFormatter()
        fmt.numberStyle = .DecimalStyle
        
        metersBeforeLabel.text = fmt.stringFromNumber(Int(input.metersDrilledYearlyBefore()))! + "m"
        metersAfterLabel.text = fmt.stringFromNumber(Int(input.metersDrilledYearlyAfter()))! + "m"
        
        tonnageBeforeLabel.text = fmt.stringFromNumber(Int(input.tonnageOutputBefore()))! + "t"
        tonnageAfterLabel.text = fmt.stringFromNumber(Int(input.tonnageOutputAfter()))! + "t"
        
        let total = input.total()
        let shanksAndBitsSavings = Int(input.shanksAndBitsSavings())
        oreOutPutLabel.text = "$" + fmt.stringFromNumber(total - shanksAndBitsSavings)!
        shanksLabel.text = "$" + fmt.stringFromNumber(shanksAndBitsSavings)!
        totalLabel.text = "$" + fmt.stringFromNumber(total)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
