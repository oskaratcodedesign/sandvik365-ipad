//
//  RoiPageContentViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 11/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit

protocol RoiSelectionContentViewControllerDelegate {
    func roiValueDidChange(itemIndex: Int, object :AnyObject)
}

class RoiSelectionContentViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    var itemIndex: Int = 0
    var selectedROICalculator: ROICalculator!
    var roiContentView: UIView?
    var toggleTimer: NSTimer?
    
    var delegate: RoiSelectionContentViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if itemIndex == 0 {
            //load products
            let productView = RoiProductView(frame: containerView.bounds)
            containerView.addSubview(productView)
            productView.loadProduct(selectedROICalculator.input)
            productView.setTranslatesAutoresizingMaskIntoConstraints(false)
            NSLayoutConstraint.activateConstraints(fillConstraints(productView, toView: containerView))
            roiContentView = productView
        }
        else {
            let numberView = RoiNumberView(frame: containerView.bounds)
            containerView.addSubview(numberView)
            numberView.loadNumber(itemIndex, roiInput: selectedROICalculator.input)
            numberView.setTranslatesAutoresizingMaskIntoConstraints(false)
            NSLayoutConstraint.activateConstraints(fillConstraints(numberView, toView: containerView))
            roiContentView = numberView;
        }
    }
    
    private func fillConstraints(fromView: UIView, toView: UIView) -> [NSLayoutConstraint] {
        let topConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        let trailConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        return [topConstraint, bottomConstraint, trailConstraint, leadingConstraint]
    }

    @IBAction func toggleLeft(sender: UIButton) {
       toggleTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("toggleLeft"), userInfo: nil, repeats: true)
    }
    
    @IBAction func toggleRight(sender: UIButton) {
        toggleTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("toggleRight"), userInfo: nil, repeats: true)
    }
    
    func toggleLeft() {
        if let numberView = roiContentView as? RoiNumberView{
            numberView.decreaseNumber(itemIndex, roiInput: selectedROICalculator.input)
            if let delegate = self.delegate {
                delegate.roiValueDidChange(itemIndex, object: numberView.numberLabel.text!)
            }
        }
        else if let productView = roiContentView as? RoiProductView{
            productView.previousProduct(selectedROICalculator.input)
            if let delegate = self.delegate {
                delegate.roiValueDidChange(itemIndex, object: selectedROICalculator.input)
            }
        }
    }
    
    func toggleRight() {
        if let numberView = roiContentView as? RoiNumberView{
            numberView.increaseNumber(itemIndex, roiInput: selectedROICalculator.input)
            if let delegate = self.delegate {
                delegate.roiValueDidChange(itemIndex, object: numberView.numberLabel.text!)
            }
        }
        else if let productView = roiContentView as? RoiProductView{
            productView.nextProduct(selectedROICalculator.input)
            if let delegate = self.delegate {
                delegate.roiValueDidChange(itemIndex, object: selectedROICalculator.input)
            }
        }
    }
    
    @IBAction func releaseAction(sender: UIButton) {
        toggleTimer?.fire()
        toggleTimer?.invalidate()
        toggleTimer = nil
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
