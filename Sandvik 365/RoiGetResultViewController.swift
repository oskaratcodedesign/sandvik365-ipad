//
//  RoiGetResultViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 22/12/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import UIKit

class RoiGetResultViewController: RoiResultViewController {

    @IBOutlet var selectionButtons: [UIButton]!
    private var selectedButton: UIButton?
    
    var selectedInput: ROIGetInput!
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func selectionAction(sender: UIButton) {
        self.selectedButton?.selected = false
        self.selectedButton = sender
        self.selectedButton?.selected = !sender.selected
        
        switch sender.tag {
        case 0:
            self.selectedInput.calculationType = .WearLife
        case 1:
            self.selectedInput.calculationType = .CostPerHour
        case 2:
            self.selectedInput.calculationType = .RevenueLoss
        case 3:
            self.selectedInput.calculationType = .Availability
        case 4:
            self.selectedInput.calculationType = .MaintenanceTime
        default:
            break
        }
    }
    
    private func setProfitLabel()
    {
        if selectedInput.calculationType != nil {
            setProfitLabelFromInput()
        }
        else {
            profitLabel.text = NSNumberFormatter().formatToUSD(0)
        }
    }
    
    private func setProfitLabelFromInput() {
        let sum = selectedInput.total()
        profitLabel.text = NSNumberFormatter().formatToUSD(sum)
    }
}
