//
//  RoiPageContentViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 11/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit

protocol RoiSelectionContentViewControllerDelegate {
    func roiValueDidChange(_ itemIndex: Int, object :AnyObject)
    func percentPPMchange(_ percent: Bool, object :AnyObject)
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
    
    fileprivate var toggleTimer: Timer?
    fileprivate var contentOffsetLast: CGPoint?
    fileprivate let swipeOffset: CGFloat = 10
    fileprivate var isKeyBoardShowing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let numberView = RoiInputView(frame: CGRect.zero, selectionInput: selectedInput)
        containerView.addSubview(numberView)
        
        numberView.loadNumber(itemIndex, selectionInput: selectedInput)
        numberView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(numberView.fillConstraints(containerView))
        roiContentView = numberView;
        roiContentView.textView.delegate = self
        spinnerScrollView.contentSize = CGSize(width: spinnerScrollView.frame.width, height: spinnerScrollView.frame.height*40)
        spinnerScrollView.contentOffset = CGPoint(x: 0, y: spinnerScrollView.contentSize.height/2)
        spinnerScrollView.delegate = self
        contentOffsetLast = spinnerScrollView.contentOffset
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(handleTap(_:)))

        spinnerScrollView.addGestureRecognizer(recognizer)
        
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        percentPPMControl.isHidden = true
        
        if let input = selectedInput as? ROICrusherInput {
            switch input.allInputs()[itemIndex] {
            case .oreGrade:
                percentPPMControl.isHidden = false
            default: break
            }
        }
        else if let input = selectedInput as? ROIEDVInput {
            switch input.allInputs()[itemIndex] {
            case .oreGrade:
                percentPPMControl.isHidden = false
            default: break
            }
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if let value = selectedInput.getInputAsString(itemIndex) {
            roiContentView.setAttributedStringWithString(value)
            return true
        }
        return false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if !selectedInput.setInput(itemIndex, stringValue: textView.attributedText!.string) {
            let alertController = UIAlertController(title: "Wrong input", message: "Please enter a valid number", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            }
            alertController.addAction(okAction)
            
            roiContentView.loadNumber(itemIndex, selectionInput: selectedInput)//load old value
            // Present Alert Controller
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            roiContentView.loadNumber(itemIndex, selectionInput: selectedInput)//load new value
            if let delegate = self.delegate {
                delegate.roiValueDidChange(itemIndex, object: roiContentView.textView.attributedText)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func handleTap(_ recognizer: UIGestureRecognizer) {
        if let value = selectedInput.getInputAsString(itemIndex) {
            roiContentView.setAttributedStringWithString(value)
            roiContentView.textView.becomeFirstResponder()
        }
    }
    
    func keyboardWillShow(_ notification: Notification) {
        let info : NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let y = containerView.frame.maxY
        let diff = y - keyboardSize!.height
        containerViewCenterY.constant += diff
        isKeyBoardShowing = true
    }
    
    func keyboardWillHide(_ notification: Notification) {
        containerViewCenterY.constant = 0
        isKeyBoardShowing = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let dy = scrollView.contentOffset.y - contentOffsetLast!.y
        if dy != 0 && scrollView.contentOffset.y > 0{
            
            if dy > swipeOffset {
                toggleUpMove()
                contentOffsetLast = scrollView.contentOffset
            }
            else if dy < -swipeOffset {
                toggleDownMove()
                contentOffsetLast = scrollView.contentOffset
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.bounds.origin = CGPoint(x: 0, y: spinnerScrollView.contentSize.height/2)
        contentOffsetLast = scrollView.contentOffset
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        spinnerScrollView.bounds.origin = CGPoint(x: 0, y: spinnerScrollView.contentSize.height/2)
        contentOffsetLast = spinnerScrollView.contentOffset
    }
    
    @IBAction func toggleUp(_ sender: UIButton) {
        if !isKeyBoardShowing {
            toggleTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(toggleUpMove), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func toggleDown(_ sender: UIButton) {
        if !isKeyBoardShowing {
            toggleTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(toggleDownMove), userInfo: nil, repeats: true)
        }
    }
   
    @IBAction func segmentChangedAction(_ sender: UISegmentedControl) {
        let isLeft = sender.selectedSegmentIndex == 0 ? true : false
        if let input = selectedInput as? ROICrusherInput {
            input.usePPM = !isLeft
        } else if let input = selectedInput as? ROIEDVInput {
            input.usePPM = !isLeft
        }
        roiContentView.loadNumber(itemIndex, selectionInput: selectedInput)//load new value
        if let delegate = self.delegate {
            delegate.roiValueDidChange(itemIndex, object: roiContentView.textView.attributedText)
            delegate.percentPPMchange(isLeft, object: roiContentView.textView.attributedText)
        }
    }
    
    func toggleDownMove() {
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
    
    func toggleUpMove() {
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
    
    @IBAction func releaseAction(_ sender: UIButton) {
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
