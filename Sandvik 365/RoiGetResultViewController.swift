//
//  RoiGetResultViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 22/12/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import UIKit

class RoiGetResultViewController: RoiResultViewController {

    @IBOutlet weak var selectedButton: UIButton!
    
    @IBOutlet weak var bareLipGraph: GraphWithLabel!
    @IBOutlet weak var weldGraph: GraphWithLabel!
    @IBOutlet weak var getGraph: GraphWithLabel!
    @IBOutlet weak var weldProfitLabel: UILabel!
    
    var selectedInput: ROIGetInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setProfitLabel()
    }
    
    override func viewDidLayoutSubviews() {
        selectionAction(selectedButton)
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
                        self.bareLipGraph.updateHeightAndSetText(multiplier, string: String(Int(value)) + "%")
                    case 1:
                        self.weldGraph.updateHeightAndSetText(multiplier, string: String(Int(value)) + "%")
                    case 2:
                        self.getGraph.updateHeightAndSetText(multiplier, string: String(Int(value)) + "%")
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
            if let percentages = selectedInput.calculationType?.percentages {
                profitLabel.text = NSNumberFormatter().formatToUSD(Double(sum) * (100 - percentages.last!)/100)
                weldProfitLabel.text = NSNumberFormatter().formatToUSD(Double(sum) * (100 - percentages[percentages.count-2])/100)
            }
        }
    }
}
