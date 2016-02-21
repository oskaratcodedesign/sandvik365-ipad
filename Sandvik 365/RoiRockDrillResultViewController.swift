//
//  RoiCalculatorViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 19/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit

class RoiRockDrillResultViewController: RoiResultViewController {

    var selectedInput: ROIRockDrillInput!
    @IBOutlet weak var RD520Button: UIButton!
    @IBOutlet weak var RD525Buttton: UIButton!
    @IBOutlet weak var roiGraphView: RoiGraphView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = NSLocalizedString("INCREASED\nVALUE BY UP TO", comment: "")

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setGraphValue()
        setProfitLabel()
    }
    
    @IBAction func RD520Action(sender: UIButton) {
        controlRockDrillProducts(selectedInput, selectedProduct: .RD520, selectedButton: sender)
        setGraphValue()
        setProfitLabel()
    }
    
    @IBAction func RD525Action(sender: UIButton) {
        controlRockDrillProducts(selectedInput, selectedProduct: .RD525, selectedButton: sender)
        setGraphValue()
        setProfitLabel()
    }
    
    private func setGraphValue() {
        
        roiGraphView.selectedROIInput = selectedInput
    }
    
    @IBAction func seeDetailAction(sender: UIButton) {
        detailsContainerView.addSubview(RoiRockDrillDetailView(frame: detailsContainerView.bounds, input: selectedInput))
        detailsContainerView.hidden = false
    }
    
    private func controlRockDrillProducts(input: ROIRockDrillInput, var selectedProduct: ROIRockDrillProduct, selectedButton: UIButton) {
        selectedButton.selected = !selectedButton.selected
        
        if selectedProduct == .RD520 {
            RD525Buttton.selected = false
        }
        else if selectedProduct == .RD525 {
            RD520Button.selected = false
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
    
    private func setProfitLabel()
    {
        if selectedInput.product != .None {
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
