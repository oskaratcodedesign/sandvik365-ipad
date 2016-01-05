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
    
    @IBOutlet weak var bareLipGraph: UIView!
    @IBOutlet var barLipHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var weldGraph: UIView!
    @IBOutlet var weldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var getGraph: UIView!
    @IBOutlet var getHeightConstraint: NSLayoutConstraint!
    
    var selectedInput: ROIGetInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setProfitLabel()
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
        
        if let percentages = self.selectedInput.calculationType?.percentages {
            if let max = percentages.maxElement() {
                for (i, value) in percentages.enumerate() {
                    let multiplier = value / max
                    switch i {
                    case 0:
                        self.barLipHeightConstraint = self.barLipHeightConstraint.changeMultiplier(CGFloat(multiplier))
                    case 1:
                        self.weldHeightConstraint = self.weldHeightConstraint.changeMultiplier(CGFloat(multiplier))
                    case 2:
                        self.getHeightConstraint = self.getHeightConstraint.changeMultiplier(CGFloat(multiplier))
                    default: break
                    }
                }
            }
            
        }
        
        setProfitLabel()
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
        if let sum = selectedInput.total() {
            profitLabel.text = NSNumberFormatter().formatToUSD(sum)
        }
    }
}
