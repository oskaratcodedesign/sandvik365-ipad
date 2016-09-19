//
//  RoiEDVResultViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 18/02/16.
//  Copyright © 2016 Commind. All rights reserved.
//
import UIKit

class RoiEDVResultViewController: RoiResultViewController {
    
    var selectedInput: ROIEDVInput!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    fileprivate var selectedButton: UIButton?
    
    @IBOutlet weak var graphView: UIView!
    @IBOutlet var graphViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = NSLocalizedString("COST PER\nBREAKDOWN", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setGraphValue()
        setProfitLabel()
    }
    
    @IBAction func firstAction(_ sender: UIButton) {
        controlInput(selectedInput, selectedService: ROIEDVCostType.extraCost, selectedButton: sender)
        setGraphValue()
        setProfitLabel()
    }
    
    @IBAction func secondAction(_ sender: UIButton) {
        controlInput(selectedInput, selectedService: ROIEDVCostType.serviceCost, selectedButton: sender)
        setGraphValue()
        setProfitLabel()
    }
    
    @IBAction func thirdAction(_ sender: UIButton) {
        controlInput(selectedInput, selectedService: ROIEDVCostType.productivityLoss, selectedButton: sender)
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
        detailsContainerView.addSubview(RoiEDVDetailView(frame: detailsContainerView.bounds, input: selectedInput))
        detailsContainerView.isHidden = false
    }
    
    fileprivate func controlInput(_ input: ROIEDVInput, selectedService: ROIEDVCostType, selectedButton: UIButton) {
        //self.selectedButton?.selected = false
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
            profitLabel.text = NumberFormatter().formatToUSD(number: 0)
        }
    }
    
    fileprivate func setProfitLabelFromInput() {
        if let sum = selectedInput.total() {
            profitLabel.text = NumberFormatter().formatToUSD(number: NSNumber(value: sum))
        }
    }
}

