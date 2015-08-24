//
//  RoiPageContentViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 11/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit

protocol RoiSelectionContentViewControllerDelegate {
    func roiValueDidChange(itemIndex: Int, text :String)
}

class RoiSelectionContentViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    var itemIndex: Int = 0
    var selectedROICalculator: ROICalculator!
    var roiContentView: RoiNumberView?
    var toggleTimer: NSTimer?
    
    var delegate: RoiSelectionContentViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if itemIndex == 0 {
            //load products
            let product = selectedROICalculator.input.product
        }
        else {
            let numberView = RoiNumberView(frame: containerView.bounds)
            
            let topConstraint = NSLayoutConstraint(item: numberView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: numberView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
            let trailConstraint = NSLayoutConstraint(item: numberView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
            let leadingConstraint = NSLayoutConstraint(item: numberView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: containerView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
            containerView.addSubview(numberView)
            numberView.loadNumber(itemIndex, roiInput: selectedROICalculator.input)
            
            numberView.setTranslatesAutoresizingMaskIntoConstraints(false)
            NSLayoutConstraint.activateConstraints([topConstraint, bottomConstraint, trailConstraint, leadingConstraint])
            roiContentView = numberView;
        }
    }

    @IBAction func toggleLeft(sender: UIButton) {
       toggleTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("toggleLeft"), userInfo: nil, repeats: true)
    }
    
    @IBAction func toggleRight(sender: UIButton) {
        toggleTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("toggleRight"), userInfo: nil, repeats: true)
    }
    
    func toggleLeft() {
        if let numberView = roiContentView {
            numberView.decreaseNumber(itemIndex, roiInput: selectedROICalculator.input)
            if let delegate = self.delegate {
                delegate.roiValueDidChange(itemIndex, text: numberView.numberLabel.text!)
            }
        }
    }
    
    func toggleRight() {
        if let numberView = roiContentView {
            numberView.increaseNumber(itemIndex, roiInput: selectedROICalculator.input)
            if let delegate = self.delegate {
                delegate.roiValueDidChange(itemIndex, text: numberView.numberLabel.text!)
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
