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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProfitLabel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        selectionAction(selectedButton)
    }

    @IBAction func detailsShowAction(_ sender: AnyObject) {
        self.detailsContainerView.isHidden = false
    }
    
    @IBAction func detailCloseAction(_ sender: AnyObject) {
        self.detailsContainerView.isHidden = true
    }

    @IBAction func selectionAction(_ sender: UIButton) {
        self.selectedButton?.isSelected = false
        self.selectedButton = sender
        self.selectedButton?.isSelected = !sender.isSelected
        
        switch sender.tag {
        case 0:
            self.selectedInput.calculationType = .wearLife
        case 1:
            self.selectedInput.calculationType = .costPerHour
        case 2:
            self.selectedInput.calculationType = .revenueLoss
        case 3:
            self.selectedInput.calculationType = .availability
        case 4:
            self.selectedInput.calculationType = .maintenanceTime
        default:
            break
        }
        
        if let percentages = self.selectedInput.calculationType?.percentages {
            if let max = percentages.max() {
                for (i, value) in percentages.enumerated() {
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
    
    fileprivate func setProfitLabel()
    {
        if selectedInput.calculationType != nil {
            setProfitLabelFromInput()
        }
        else {
            profitLabel.text = NumberFormatter().formatToUSD(0)
        }
    }
    
    fileprivate func setProfitLabelFromInput() {
        if let sum = selectedInput.total() {
            let percentages = ROIGetCalculationType.costPerHour.percentages
            profitLabel.text = NumberFormatter().formatToUSD(Double(sum) * (100 - percentages.last!)/100)
            weldProfitLabel.text = NumberFormatter().formatToUSD(Double(sum) * (100 - percentages[percentages.count-2])/100)
        }
    }
}
