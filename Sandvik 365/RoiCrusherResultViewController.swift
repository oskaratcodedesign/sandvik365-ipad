//
//  RoiCalculatorViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 19/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit

class RoiCrusherResultViewController: UIViewController {

    var selectedInput: ROICrusherInput!
    @IBOutlet weak var seeDetailButton: UIButton!
    @IBOutlet weak var closeDetailButton: UIButton!
    @IBOutlet weak var profitLabel: UILabel!
    @IBOutlet weak var rampUpButton: UIButton!
    @IBOutlet weak var conditionButton: UIButton!
    @IBOutlet weak var maintenenceButton: UIButton!
    @IBOutlet weak var protectiveButton: UIButton!
    private var selectedButton: UIButton?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsContainerView: UIView!
    @IBOutlet weak var graphContainerView: UIView!
    @IBOutlet weak var graphLabel: UILabel!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet var graphViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadServiceButtons()
        setBorderOnDetailButton()
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
        let multiplier = Double(selectedInput.total()) / (selectedInput.maxTotal())
        if multiplier > 0 {
            self.graphView.hidden = false
            let newConstraint = self.graphViewHeightConstraint.changeMultiplier(CGFloat(multiplier))
            NSLayoutConstraint.deactivateConstraints([self.graphViewHeightConstraint])
            NSLayoutConstraint.activateConstraints([newConstraint])
            self.graphViewHeightConstraint = newConstraint
        } else {
            self.graphView.hidden = true
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
        let sum = selectedInput.total()
        profitLabel.text = NSNumberFormatter().formatToUSD(sum)
    }
    
    private func setBorderOnDetailButton() {
        let layer = self.seeDetailButton.layer
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = self.seeDetailButton.titleLabel?.textColor.CGColor
    }
    
    private func loadServiceButtons() {
        var size = rampUpButton.bounds.size
        size.width = size.height
        let color = UIColor(red: 0.890, green:0.431, blue:0.153, alpha:1.000)
        let serviceButtons = [rampUpButton, conditionButton, maintenenceButton, protectiveButton]
        for button in serviceButtons {
            let borderimage = CALayer().roundImage(CGRectMake(0, 0, size.width, size.height), fill: false, color: color)
            button.setImage(borderimage, forState: .Normal)
            let fillimage = CALayer().roundImage(CGRectMake(0, 0, size.width, size.height), fill: true, color: color)
            button.setImage(fillimage, forState: .Highlighted)
            button.setImage(fillimage, forState: .Selected)
        }
    }
}
