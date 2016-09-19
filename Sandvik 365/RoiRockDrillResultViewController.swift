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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setGraphValue()
        setProfitLabel()
    }
    
    @IBAction func RD520Action(_ sender: UIButton) {
        controlRockDrillProducts(selectedInput, selectedProductConst: .rd520, selectedButton: sender)
        setGraphValue()
        setProfitLabel()
    }
    
    @IBAction func RD525Action(_ sender: UIButton) {
        controlRockDrillProducts(selectedInput, selectedProductConst: .rd525, selectedButton: sender)
        setGraphValue()
        setProfitLabel()
    }
    
    fileprivate func setGraphValue() {
        
        roiGraphView.selectedROIInput = selectedInput
    }
    
    @IBAction func seeDetailAction(_ sender: UIButton) {
        detailsContainerView.addSubview(RoiRockDrillDetailView(frame: detailsContainerView.bounds, input: selectedInput))
        detailsContainerView.isHidden = false
    }
    
    fileprivate func controlRockDrillProducts(_ input: ROIRockDrillInput, selectedProductConst: ROIRockDrillProduct, selectedButton: UIButton) {
        var selectedProduct = selectedProductConst
        selectedButton.isSelected = !selectedButton.isSelected
        
        if selectedProduct == .rd520 {
            RD525Buttton.isSelected = false
        }
        else if selectedProduct == .rd525 {
            RD520Button.isSelected = false
        }
        
        if !selectedButton.isSelected {
            selectedProduct = .none
            profitLabel.isHidden = true
        }
        else {
            profitLabel.isHidden = false
        }
        
        input.product = selectedProduct
        roiGraphView.selectedROIInput = input
    }
    
    fileprivate func setProfitLabel()
    {
        if selectedInput.product != .none {
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
