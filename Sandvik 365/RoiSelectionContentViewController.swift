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
    func percentPPMchange(percent: Bool, object :AnyObject)
}

class RoiSelectionContentViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {

    @IBOutlet weak var containerViewCenterY: NSLayoutConstraint!
    @IBOutlet weak var spinnerScrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var percentPPMControl: UISegmentedControl!
    
    var itemIndex: Int = 0
    var selectedInput: SelectionInput!
    var roiContentView: RoiInputView!
    var delegate: RoiSelectionContentViewControllerDelegate?
    
    private var toggleTimer: NSTimer?
    private var contentOffsetLast: CGPoint?
    private let swipeOffset: CGFloat = 10
    private var isKeyBoardShowing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let numberView = RoiInputView(frame: CGRectZero, selectionInput: selectedInput)
        containerView.addSubview(numberView)
        
        numberView.loadNumber(itemIndex, selectionInput: selectedInput)
        numberView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints(fillConstraints(numberView, toView: containerView))
        roiContentView = numberView;
        roiContentView.textView.delegate = self
        spinnerScrollView.contentSize = CGSizeMake(spinnerScrollView.frame.width, spinnerScrollView.frame.height*40)
        spinnerScrollView.contentOffset = CGPointMake(0, spinnerScrollView.contentSize.height/2)
        spinnerScrollView.delegate = self
        contentOffsetLast = spinnerScrollView.contentOffset
        let recognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))

        spinnerScrollView.addGestureRecognizer(recognizer)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        percentPPMControl.hidden = true
        if let input = selectedInput as? ROICrusherInput {
            switch input.allInputs()[itemIndex] {
            case .OreGrade:
                percentPPMControl.hidden = false
            default: break
            }
        }
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if let value = selectedInput.getInputAsString(itemIndex) {
            roiContentView.setAttributedStringWithString(value)
            return true
        }
        return false
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if !selectedInput.setInput(itemIndex, stringValue: textView.attributedText!.string) {
            let alertController = UIAlertController(title: "Wrong input", message: "Please enter a valid number", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            }
            alertController.addAction(okAction)
            
            roiContentView.loadNumber(itemIndex, selectionInput: selectedInput)//load old value
            // Present Alert Controller
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            roiContentView.loadNumber(itemIndex, selectionInput: selectedInput)//load new value
            if let delegate = self.delegate {
                delegate.roiValueDidChange(itemIndex, object: roiContentView.textView.attributedText)
            }
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func handleTap(recognizer: UIGestureRecognizer) {
        if let value = selectedInput.getInputAsString(itemIndex) {
            roiContentView.setAttributedStringWithString(value)
            roiContentView.textView.becomeFirstResponder()
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let y = CGRectGetMaxY(containerView.frame)
        let diff = y - keyboardSize!.height
        containerViewCenterY.constant += diff
        isKeyBoardShowing = true
    }
    
    func keyboardWillHide(notification: NSNotification) {
        containerViewCenterY.constant = 0
        isKeyBoardShowing = false
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let dy = scrollView.contentOffset.y - contentOffsetLast!.y
        if dy != 0 && scrollView.contentOffset.y > 0{
            
            if dy > swipeOffset {
                toggleUp()
                contentOffsetLast = scrollView.contentOffset
            }
            else if dy < -swipeOffset {
                toggleDown()
                contentOffsetLast = scrollView.contentOffset
            }
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollView.bounds.origin = CGPointMake(0, spinnerScrollView.contentSize.height/2)
        contentOffsetLast = scrollView.contentOffset
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        spinnerScrollView.bounds.origin = CGPointMake(0, spinnerScrollView.contentSize.height/2)
        contentOffsetLast = spinnerScrollView.contentOffset
    }
    
    private func fillConstraints(fromView: UIView, toView: UIView) -> [NSLayoutConstraint] {
        let topConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        let trailConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        return [topConstraint, bottomConstraint, trailConstraint, leadingConstraint]
    }
    
    @IBAction func toggleUp(sender: UIButton) {
        if !isKeyBoardShowing {
            toggleTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("toggleUp"), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func toggleDown(sender: UIButton) {
        if !isKeyBoardShowing {
            toggleTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("toggleDown"), userInfo: nil, repeats: true)
        }
    }
   
    @IBAction func segmentChangedAction(sender: UISegmentedControl) {
        let isLeft = sender.selectedSegmentIndex == 0 ? true : false
        if let input = selectedInput as? ROICrusherInput {
            input.usePPM = !isLeft
            roiContentView.loadNumber(itemIndex, selectionInput: selectedInput)//load new value
            if let delegate = self.delegate {
                delegate.roiValueDidChange(itemIndex, object: roiContentView.textView.attributedText)
                delegate.percentPPMchange(isLeft, object: roiContentView.textView.attributedText)
            }
        }
    }
    
    func toggleDown() {
        if let numberView = roiContentView{
            numberView.decreaseNumber(itemIndex, selectionInput: selectedInput)
            if let delegate = self.delegate {
                delegate.roiValueDidChange(itemIndex, object: numberView.textView.attributedText)
            }
        }
        /*else if let productView = roiContentView as? RoiProductView{
            //productView.previousProduct(selectedROICalculator.input)
            if let delegate = self.delegate {
                delegate.roiValueDidChange(itemIndex, object: selectedROICalculator.input)
            }
        }*/
    }
    
    func toggleUp() {
        if let numberView = roiContentView{
            numberView.increaseNumber(itemIndex, selectionInput: selectedInput)
            if let delegate = self.delegate {
                delegate.roiValueDidChange(itemIndex, object: numberView.textView.attributedText)
            }
        }
        /*else if let productView = roiContentView as? RoiProductView{
            //productView.nextProduct(selectedROICalculator.input)
            if let delegate = self.delegate {
                delegate.roiValueDidChange(itemIndex, object: selectedROICalculator.input)
            }
        }*/
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
