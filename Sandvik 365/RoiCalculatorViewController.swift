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
    @IBOutlet var serviceButtons: [UIButton]!
    @IBOutlet weak var roiGraphView: RoiGraphView!
    @IBOutlet weak var detailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadServiceButtons()
        setBorderOnDetailButton()
        roiGraphView.selectedROICalculator = selectedROICalculator
    }
    
    @IBAction func rampUpAction(sender: UIButton) {
        sender.selected = !sender.selected
        roiGraphView.setSelectedService(sender.selected, service: ROIService.RampUp)
    }
    
    @IBAction func conditionAction(sender: UIButton) {
        sender.selected = !sender.selected
        roiGraphView.setSelectedService(sender.selected, service: ROIService.ConditionInspection)
    }
    
    @IBAction func maintenanceAction(sender: UIButton) {
        sender.selected = !sender.selected
        roiGraphView.setSelectedService(sender.selected, service: ROIService.MaintenancePlanning)
    }
    
    @IBAction func protectiveAction(sender: UIButton) {
        sender.selected = !sender.selected
        roiGraphView.setSelectedService(sender.selected, service: ROIService.Protective)
    }
    
    private func setBorderOnDetailButton() {
        var layer = self.detailButton.layer
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = self.detailButton.titleLabel?.textColor.CGColor
    }
    
    private func loadServiceButtons() {
        var size = serviceButtons[0].bounds.size
        size.width = size.height
        let color = UIColor(red: 0.890, green:0.431, blue:0.153, alpha:1.000)
        for button in serviceButtons {
            let borderimage = roundImage(size, fill: false, color: color)
            button.setImage(borderimage, forState: .Normal)
            let fillimage = roundImage(size, fill: true, color: color)
            button.setImage(fillimage, forState: .Highlighted)
            button.setImage(fillimage, forState: .Selected)
        }
    }
    
    private func roundImage(size: CGSize, fill: Bool, color: UIColor) -> UIImage? {
        var layer = CALayer()
        layer.frame = CGRectMake(0, 0, size.width, size.height)
        layer.cornerRadius = size.width/2
        layer.masksToBounds = true
        if fill {
            layer.backgroundColor = color.CGColor
        }
        else {
            layer.borderWidth = 1
            layer.borderColor = color.CGColor
        }
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
        layer.renderInContext(UIGraphicsGetCurrentContext())
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return roundedImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
