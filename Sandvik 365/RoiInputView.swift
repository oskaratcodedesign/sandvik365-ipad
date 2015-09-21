//
//  RoiNumberView.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 12/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit
import NibDesignable

class RoiInputView: NibDesignable {

    @IBOutlet weak var numberLabel: UILabel!
    
    func loadNumber(itemIndex: Int, roiInput: ROIInput) {
        self.numberLabel.text = roiInput.changeInput(itemIndex, change: .Load)
    }
    
    func increaseNumber(itemIndex: Int, roiInput: ROIInput) {
        self.numberLabel.text = roiInput.changeInput(itemIndex, change: .Increase)
    }
    
    func decreaseNumber(itemIndex: Int, roiInput: ROIInput) {
        self.numberLabel.text = roiInput.changeInput(itemIndex, change: .Decrease)
    }
}
