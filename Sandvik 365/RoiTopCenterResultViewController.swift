//
//  RoiTopCenterViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 17/03/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import UIKit

class RoiTopCenterResultViewController: RoiResultViewController {
    
    var selectedInput: ROITopCenterInput!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    private var selectedButton: UIButton?
    
    @IBOutlet weak var graphView: UIView!
    @IBOutlet var graphViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = NSLocalizedString("TOTAL BIT ECONOMY", comment: "")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setGraphValue()
        setProfitLabel()
    }
    
    @IBAction func firstAction(sender: UIButton) {
        controlInput(selectedInput, selectedService: ROITopCenterCostType.SavedBitCost, selectedButton: sender)
        setGraphValue()
        setProfitLabel()
    }
    
    @IBAction func secondAction(sender: UIButton) {
        controlInput(selectedInput, selectedService: ROITopCenterCostType.SavedGrindingCost, selectedButton: sender)
        setGraphValue()
        setProfitLabel()
    }
    
    @IBAction func thirdAction(sender: UIButton) {
        controlInput(selectedInput, selectedService: ROITopCenterCostType.SavedValueCost, selectedButton: sender)
        setGraphValue()
        setProfitLabel()
    }
    
    private func setGraphValue() {
        
        if let total = selectedInput.total() {
            var multiplier = Double(total) / (selectedInput.maxTotal())
            multiplier = max(multiplier, 0.0001)
            self.graphViewHeightConstraint.active = false
            self.graphViewHeightConstraint = self.graphViewHeightConstraint.newMultiplier(CGFloat(multiplier))
            self.graphViewHeightConstraint.active = true
            UIView.animateWithDuration(0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func closeDetailAction(sender: UIButton) {
        for view in detailsContainerView.subviews {
            view.removeFromSuperview()
        }
    }
    @IBAction func seeDetailAction(sender: UIButton) {
        detailsContainerView.addSubview(RoiTopCenterDetailView(frame: detailsContainerView.bounds, input: selectedInput))
        detailsContainerView.hidden = false
    }
    
    private func controlInput(input: ROITopCenterInput, selectedService: ROITopCenterCostType, selectedButton: UIButton) {
        self.selectedButton = selectedButton
        self.selectedButton?.selected = !selectedButton.selected
        
        if selectedButton.selected {
            input.costTypes.insert(selectedService)
        }
        else {
            input.costTypes.remove(selectedService)
        }
    }
    
    private func setProfitLabel()
    {
        if !self.selectedInput.costTypes.isEmpty {
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