//
//  RoiNumberView.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 12/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit
import NibDesignable

class RoiNumberView: NibDesignable {

    @IBOutlet weak var numberLabel: UILabel!
    
    func loadNumber(itemIndex :Int, roiInput :ROIInput)
    {
        setNumber(itemIndex, roiInput: roiInput, add: 0)
    }
    
    func increaseNumber(itemIndex :Int, roiInput :ROIInput)
    {
        setNumber(itemIndex, roiInput: roiInput, add: 1)
    }
    
    func decreaseNumber(itemIndex :Int, roiInput :ROIInput)
    {
        setNumber(itemIndex, roiInput: roiInput, add: -1)
    }
    
    private func setNumber(itemIndex :Int, roiInput :ROIInput, add :Int)
    {
        switch itemIndex {
        case 1:
            let number = roiInput.numberOfProducts ?? 0
            let newnumber = Int(number) + add
            if newnumber >= 0 {
                self.numberLabel.text = String(newnumber);
                roiInput.numberOfProducts = UInt(newnumber);
            }
        case 2:
            let number = roiInput.oreGrade ?? 0
            let newnumber = Int(number) + add
            if newnumber >= 0 {
                self.numberLabel.text = String(newnumber) + "%";
                roiInput.oreGrade = UInt(newnumber);
            }
        case 3:
            let number = roiInput.efficiency ?? 0
            let newnumber = Int(number) + add
            if newnumber >= 0 {
                self.numberLabel.text = String(newnumber) + "%";
                roiInput.efficiency = UInt(newnumber);
            }
        case 4:
            let number = roiInput.price ?? 0
            let newnumber = Int(number) + add
            if newnumber >= 0 {
                self.numberLabel.text = "$" + String(newnumber);
                roiInput.price = UInt(newnumber);
            }
        default:
            break
        }
    }
}
