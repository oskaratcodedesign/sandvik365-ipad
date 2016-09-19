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
    fileprivate var selectedButton: UIButton?
    
    @IBOutlet weak var graphView: UIView!
    @IBOutlet var graphViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = NSLocalizedString("TOTAL BIT ECONOMY", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setGraphValue()
        setProfitLabel()
    }
    
    @IBAction func firstAction(_ sender: UIButton) {
        controlInput(selectedInput, selectedService: ROITopCenterCostType.savedBitCost, selectedButton: sender)
        setGraphValue()
        setProfitLabel()
    }
    
    @IBAction func secondAction(_ sender: UIButton) {
        controlInput(selectedInput, selectedService: ROITopCenterCostType.savedGrindingCost, selectedButton: sender)
        setGraphValue()
        setProfitLabel()
    }
    
    @IBAction func thirdAction(_ sender: UIButton) {
        controlInput(selectedInput, selectedService: ROITopCenterCostType.savedValueCost, selectedButton: sender)
        setGraphValue()
        setProfitLabel()
    }
    
    fileprivate func setGraphValue() {
        
        if let total = selectedInput.total() {
            var multiplier = Double(total) / (selectedInput.maxTotal())
            multiplier = max(multiplier, 0.0001)
            self.graphViewHeightConstraint.isActive = false
            self.graphViewHeightConstraint = self.graphViewHeightConstraint.newMultiplier(CGFloat(multiplier))
            self.graphViewHeightConstraint.isActive = true
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            }) 
        }
    }
    
    @IBAction func closeDetailAction(_ sender: UIButton) {
        for view in detailsContainerView.subviews {
            view.removeFromSuperview()
        }
    }
    @IBAction func seeDetailAction(_ sender: UIButton) {
        detailsContainerView.addSubview(RoiTopCenterDetailView(frame: detailsContainerView.bounds, input: selectedInput))
        detailsContainerView.isHidden = false
    }
    
    fileprivate func controlInput(_ input: ROITopCenterInput, selectedService: ROITopCenterCostType, selectedButton: UIButton) {
        self.selectedButton = selectedButton
        self.selectedButton?.isSelected = !selectedButton.isSelected
        
        if selectedButton.isSelected {
            input.costTypes.insert(selectedService)
        }
        else {
            input.costTypes.remove(selectedService)
        }
    }
    
    fileprivate func setProfitLabel()
    {
        if !self.selectedInput.costTypes.isEmpty {
            setProfitLabelFromInput()
        }
        else {
            profitLabel.text = NumberFormatter().formatToUSD(0)
        }
    }
    
    fileprivate func setProfitLabelFromInput() {
        if let sum = selectedInput.total() {
            profitLabel.text = NumberFormatter().formatToUSD(sum)
        }
    }
}
