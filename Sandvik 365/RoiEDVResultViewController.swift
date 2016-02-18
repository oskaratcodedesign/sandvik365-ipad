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
    private var selectedButton: UIButton?
    
    @IBOutlet weak var graphView: UIView!
    @IBOutlet var graphViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = NSLocalizedString("TRAMP LOSS", comment: "")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setGraphValue()
        setProfitLabel()
        if self.selectedInput.costType == nil {
            self.selectedButton?.selected = false
        }
    }
    
    @IBAction func firstAction(sender: UIButton) {
        controlInput(selectedInput, selectedService: ROIEDVCostType.ExtraCost, selectedButton: sender)
        setGraphValue()
        setProfitLabel()
    }
    
    @IBAction func secondAction(sender: UIButton) {
        controlInput(selectedInput, selectedService: ROIEDVCostType.ServiceCost, selectedButton: sender)
        setGraphValue()
        setProfitLabel()
    }
    
    @IBAction func thirdAction(sender: UIButton) {
        controlInput(selectedInput, selectedService: ROIEDVCostType.ProductivityLoss, selectedButton: sender)
        setGraphValue()
        setProfitLabel()
    }
    
    private func setGraphValue() {
        
        self.graphView.hidden = true
        if let total = selectedInput.total() {
            let multiplier = Double(total) / (selectedInput.maxTotal())
            if multiplier > 0 {
                self.graphView.hidden = false
                self.graphViewHeightConstraint = self.graphViewHeightConstraint.changeMultiplier(CGFloat(multiplier))
            }
        }
    }
    
    @IBAction func closeDetailAction(sender: UIButton) {
        for view in detailsContainerView.subviews {
            view.removeFromSuperview()
        }
    }
    @IBAction func seeDetailAction(sender: UIButton) {
        //detailsContainerView.addSubview(RoiCrusherDetailView(frame: detailsContainerView.bounds, input: selectedInput))
        detailsContainerView.hidden = false
    }
    
    private func controlInput(input: ROIEDVInput, selectedService: ROIEDVCostType, selectedButton: UIButton) {
        self.selectedButton?.selected = false
        self.selectedButton = selectedButton
        self.selectedButton?.selected = !selectedButton.selected
        
        input.costType = selectedService
    }
    
    private func setProfitLabel()
    {
        if self.selectedInput.costType == nil {
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

