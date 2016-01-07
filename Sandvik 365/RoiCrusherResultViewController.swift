//
//  RoiCalculatorViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 19/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit

class RoiCrusherResultViewController: RoiResultViewController {

    var selectedInput: ROICrusherInput!
    @IBOutlet weak var rampUpButton: UIButton!
    @IBOutlet weak var conditionButton: UIButton!
    @IBOutlet weak var maintenenceButton: UIButton!
    @IBOutlet weak var protectiveButton: UIButton!
    private var selectedButton: UIButton?
    
    @IBOutlet weak var graphLabel: UILabel!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet var graphViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = NSLocalizedString("INCREASED\nVALUE BY UP TO", comment: "")
        let attrString = NSMutableAttributedString(string: "+ 80%", attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 64.0)!])
        attrString.appendAttributedString(NSAttributedString(string: "\nCAPITAL SPARE PARTS\nCOVERED", attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorp-Light", size: 16.0)!]))
        self.graphLabel.attributedText = attrString
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setGraphValue()
        setProfitLabel()
        if self.selectedInput.services.isEmpty {
            self.selectedButton?.selected = false
        }
        conditionButton.hidden = false
        maintenenceButton.hidden = false
        protectiveButton.hidden = false
        rampUpButton.hidden = false
        if selectedInput.operation.value as! OperationType == OperationType.New {
            conditionButton.hidden = true
            maintenenceButton.hidden = true
            protectiveButton.hidden = true
        }
        else {
            rampUpButton.hidden = true
        }
    }
    
    @IBAction func rampUpAction(sender: UIButton) {
        controlCrusherServices(selectedInput, selectedService: .RampUp, selectedButton: sender)
        self.graphLabel.hidden = true
        setGraphValue()
        setProfitLabel()
    }
    
    @IBAction func conditionAction(sender: UIButton) {
        controlCrusherServices(selectedInput, selectedService: .ConditionInspection, selectedButton: sender)
        self.graphLabel.hidden = true
        setGraphValue()
        setProfitLabel()
    }
    
    @IBAction func maintenanceAction(sender: UIButton) {
        controlCrusherServices(selectedInput, selectedService: .MaintenancePlanning, selectedButton: sender)
        self.graphLabel.hidden = true
        setGraphValue()
        setProfitLabel()
    }
    
    @IBAction func protectiveAction(sender: UIButton) {
        controlCrusherServices(selectedInput, selectedService: .MaintenancePlanning, selectedButton: sender)
        setGraphValue()
        self.graphLabel.hidden = false
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
        detailsContainerView.addSubview(RoiCrusherDetailView(frame: detailsContainerView.bounds, input: selectedInput))
        detailsContainerView.hidden = false
    }
    
    private func controlCrusherServices(input: ROICrusherInput, selectedService: ROICrusherService, selectedButton: UIButton) {
        self.selectedButton?.selected = false
        self.selectedButton = selectedButton
        self.selectedButton?.selected = !selectedButton.selected
        
        input.services.removeAll()
        
        if selectedButton.selected {
            input.services.insert(selectedService)
        }
    }
    
    private func setProfitLabel()
    {
        if !selectedInput.services.isEmpty {
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
