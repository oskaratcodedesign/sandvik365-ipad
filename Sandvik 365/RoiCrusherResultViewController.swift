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
    fileprivate var selectedButton: UIButton?
    
    @IBOutlet weak var compareProgramsImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var graphLabel: UILabel!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet var graphViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = NSLocalizedString("INCREASED\nVALUE BY UP TO", comment: "")
        let attrString = NSMutableAttributedString(string: "+ 80%", attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 64.0)!])
        attrString.append(NSAttributedString(string: "\nCOVERAGE ON CAPITAL\nSPARE PARTS", attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorp-Light", size: 16.0)!]))
        self.graphLabel.attributedText = attrString
        if let imageurl = UserDefaults.standard.url(forKey: JSONManager.serviceHandlerImageKey) {
            if let image = ImageCache.getImage(imageurl) {
                self.compareProgramsImageView.image = image
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setGraphValue()
        setProfitLabel()
        if self.selectedInput.services.isEmpty {
            self.selectedButton?.isSelected = false
        }
        conditionButton.isHidden = false
        maintenenceButton.isHidden = false
        protectiveButton.isHidden = false
        rampUpButton.isHidden = false
        if selectedInput.operation.value as! OperationType == OperationType.New {
            conditionButton.isHidden = true
            maintenenceButton.isHidden = true
            protectiveButton.isHidden = true
        }
        else {
            rampUpButton.isHidden = true
        }
    }
    
    @IBAction func rampUpAction(_ sender: UIButton) {
        controlCrusherServices(selectedInput, selectedService: .rampUp, selectedButton: sender)
        self.graphLabel.isHidden = true
        setGraphValue()
        setProfitLabel()
    }
    
    @IBAction func conditionAction(_ sender: UIButton) {
        controlCrusherServices(selectedInput, selectedService: .conditionInspection, selectedButton: sender)
        self.graphLabel.isHidden = true
        setGraphValue()
        setProfitLabel()
    }
    
    @IBAction func maintenanceAction(_ sender: UIButton) {
        controlCrusherServices(selectedInput, selectedService: .maintenancePlanning, selectedButton: sender)
        self.graphLabel.isHidden = true
        setGraphValue()
        setProfitLabel()
    }
    
    @IBAction func protectiveAction(_ sender: UIButton) {
        controlCrusherServices(selectedInput, selectedService: .maintenancePlanning, selectedButton: sender)
        setGraphValue()
        self.graphLabel.isHidden = false
        setProfitLabel()
    }
    
    @IBAction func scrollLeftAction(_ sender: AnyObject) {
        self.scrollView.scrollRectToVisible(CGRect(origin: CGPoint(x:0, y: 0), size: scrollView.bounds.size), animated: true)
        if let vc = self.parent?.parent as? RoiSelectionViewController {
            vc.selectionContainer.isHidden = false
            vc.titleLabel.isHidden = false
        }
    }
    
    @IBAction func scrollRightAction(_ sender: AnyObject) {
        self.scrollView.scrollRectToVisible(CGRect(origin: CGPoint(x: self.scrollView.bounds.size.width, y: 0), size: scrollView.bounds.size), animated: true)
        
        if let vc = self.parent?.parent as? RoiSelectionViewController {
            vc.selectionContainer.isHidden = true
            vc.titleLabel.isHidden = true
        }
    }
    
    fileprivate func setGraphValue() {
        
        self.graphView.isHidden = true
        if let total = selectedInput.total() {
            let multiplier = Double(total) / (selectedInput.maxTotal())
            if multiplier > 0 {
                self.graphView.isHidden = false
                self.graphViewHeightConstraint = self.graphViewHeightConstraint.changeMultiplier(CGFloat(multiplier))
            }
        }
    }
    
    @IBAction func closeDetailAction(_ sender: UIButton) {
        for view in detailsContainerView.subviews {
            view.removeFromSuperview()
        }
    }
    @IBAction func seeDetailAction(_ sender: UIButton) {
        detailsContainerView.addSubview(RoiCrusherDetailView(frame: detailsContainerView.bounds, input: selectedInput))
        detailsContainerView.isHidden = false
    }
    
    fileprivate func controlCrusherServices(_ input: ROICrusherInput, selectedService: ROICrusherService, selectedButton: UIButton) {
        self.selectedButton?.isSelected = false
        self.selectedButton = selectedButton
        self.selectedButton?.isSelected = !selectedButton.isSelected
        
        input.services.removeAll()
        
        if selectedButton.isSelected {
            input.services.insert(selectedService)
        }
    }
    
    fileprivate func setProfitLabel()
    {
        if !selectedInput.services.isEmpty {
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
