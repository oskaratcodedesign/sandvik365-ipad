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
        
        metersBeforeLabel.text = String(Int(input.metersDrilledYearlyBefore())) + "m";
        metersAfterLabel.text = String(Int(input.metersDrilledYearlyAfter())) + "m";
        
        tonnageBeforeLabel.text = String(Int(input.tonnageOutputBefore())) + "t";
        tonnageAfterLabel.text = String(Int(input.tonnageOutputAfter())) + "t";
        
        let total = Int(input.total())
        let shanksAndBitsSavings = Int(input.shanksAndBitsSavings())
        oreOutPutLabel.text = "$" + String(total - shanksAndBitsSavings);
        shanksLabel.text = "$" + String(shanksAndBitsSavings);
        totalLabel.text = "$" + String(total);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
