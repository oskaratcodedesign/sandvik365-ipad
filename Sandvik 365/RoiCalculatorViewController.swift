//
//  RoiCalculatorViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 19/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit

class RoiCalculatorViewController: UIViewController {

    var selectedROICalculator: ROICalculator!
    @IBOutlet weak var roiGraphView: RoiGraphView!
    @IBOutlet weak var seeDetailButton: UIButton!
    @IBOutlet weak var closeDetailButton: UIButton!
    @IBOutlet weak var profitLabel: UILabel!
    @IBOutlet weak var rampUpButton: UIButton!
    @IBOutlet weak var conditionButton: UIButton!
    @IBOutlet weak var maintenenceButton: UIButton!
    @IBOutlet weak var protectiveButton: UIButton!
    private var selectedButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsContainerView: UIView!
    @IBOutlet weak var graphContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadServiceButtons()
        setBorderOnDetailButton()
        if (selectedROICalculator.input as? ROICrusherInput != nil) {
            titleLabel.text = NSLocalizedString("INCREASED\nVALUE BY UP TO", comment: "")
        }
        else if (selectedROICalculator.input as? ROIRockDrillInput != nil) {
            titleLabel.text = NSLocalizedString("INCREASED REVENUE DUE\nTO INCREASED ORE OUTPUT", comment: "")
            //TODO temp stuff
            maintenenceButton.hidden = true
            rampUpButton.setTitle("RD520", forState: .Normal)
            
            conditionButton.setAttributedTitle(nil, forState: .Normal)
            conditionButton.setTitle("RD525", forState: .Normal)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        roiGraphView.selectedROIInput = selectedROICalculator.input
        setProfitLabel()
        if let input = selectedROICalculator.input as? ROICrusherInput {
            conditionButton.hidden = false
            maintenenceButton.hidden = false
            protectiveButton.hidden = false
            rampUpButton.hidden = false
            if input.operation.value as! OperationType == OperationType.New {
                conditionButton.hidden = true
                maintenenceButton.hidden = true
                protectiveButton.hidden = true
            }
            else {
                rampUpButton.hidden = true
            }
        }
    }
    
    @IBAction func rampUpAction(sender: UIButton) {
        if let input = selectedROICalculator.input as? ROICrusherInput {
            controlCrusherServices(input, selectedService: .RampUp, selectedButton: sender)
        }
        else if let input = selectedROICalculator.input as? ROIRockDrillInput {
            controlRockDrillProducts(input, selectedProduct: .RD520, selectedButton: sender)
        }
        setProfitLabel()
    }
    
    @IBAction func conditionAction(sender: UIButton) {
        if let input = selectedROICalculator.input as? ROICrusherInput {
            controlCrusherServices(input, selectedService: .ConditionInspection, selectedButton: sender)
        }
        else if let input = selectedROICalculator.input as? ROIRockDrillInput {
            controlRockDrillProducts(input, selectedProduct: .RD525, selectedButton: sender)
        }
        setProfitLabel()
    }
    
    @IBAction func maintenanceAction(sender: UIButton) {
        if let input = selectedROICalculator.input as? ROICrusherInput {
            controlCrusherServices(input, selectedService: .MaintenancePlanning, selectedButton: sender)
        }
        setProfitLabel()
    }
    
    @IBAction func protectiveAction(sender: UIButton) {
        if let input = selectedROICalculator.input as? ROICrusherInput {
            controlCrusherServices(input, selectedService: .MaintenancePlanning, selectedButton: sender)
        }
        setProfitLabel()
    }
    
    @IBAction func closeDetailAction(sender: UIButton) {
        for view in detailsContainerView.subviews {
            view.removeFromSuperview()
        }
        /*graphContainerView.hidden = false
        seeDetailButton.hidden = false
        detailsContainerView.hidden = true
        closeDetailButton.hidden = true*/
    }
    @IBAction func seeDetailAction(sender: UIButton) {
        if let input = selectedROICalculator.input as? ROICrusherInput {
            detailsContainerView.addSubview(RoiCrusherDetailView(frame: detailsContainerView.bounds, input: input))
        }
        else if let input = selectedROICalculator.input as? ROIRockDrillInput {
            detailsContainerView.addSubview(RoiRockDrillDetailView(frame: detailsContainerView.frame, input: input))
        }
        detailsContainerView.hidden = false
        /*graphContainerView.hidden = true
        seeDetailButton.hidden = true
        detailsContainerView.hidden = false
        closeDetailButton.hidden = false*/
    }
    
    private func controlRockDrillProducts(input: ROIRockDrillInput, var selectedProduct: ROIRockDrillProduct, selectedButton: UIButton) {
        selectedButton.selected = !selectedButton.selected
        
        if selectedProduct == .RD520 {
            conditionButton.selected = false
        }
        else if selectedProduct == .RD525 {
            rampUpButton.selected = false
        }
        
        if !selectedButton.selected {
            selectedProduct = .None
            profitLabel.hidden = true
        }
        else {
            profitLabel.hidden = false
        }
        
        input.product = selectedProduct
        roiGraphView.selectedROIInput = input
    }
    
    private func controlCrusherServices(input: ROICrusherInput, selectedService: ROICrusherService, selectedButton: UIButton) {
        if self.selectedButton != nil {
            self.selectedButton.selected = false
        }
        self.selectedButton = selectedButton
        self.selectedButton.selected = !selectedButton.selected
        
        input.services.removeAll()
        
        if selectedButton.selected {
            input.services.insert(selectedService)
        }
        /*else {
            input.services.remove(selectedService)
        }
        
        if selectedService == .MaintenancePlanning {
            input.services.remove(.ConditionInspection) // always remove if selected
            conditionButton.selected = selectedButton.selected
        }
        
        if selectedService == .ConditionInspection && input.services.contains(.MaintenancePlanning){
            input.services.remove(.MaintenancePlanning) // always remove if selected
            maintenenceButton.selected = selectedButton.selected
        }*/
        
        roiGraphView.selectedROIInput = input
    }
    
    private func setProfitLabel()
    {
        if let input = selectedROICalculator.input as? ROICrusherInput {
            if input.services.count > 0 {
                setProfitLabelFromInput()
            }
            else {
                profitLabel.text = "$0"
            }
            
        }
    }
    
    private func setProfitLabelFromInput() {
        let sum = selectedROICalculator.input.total()
        
        let fmt = NSNumberFormatter()
        fmt.numberStyle = .DecimalStyle
        
        profitLabel.text = "$" + fmt.stringFromNumber(sum)!
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
