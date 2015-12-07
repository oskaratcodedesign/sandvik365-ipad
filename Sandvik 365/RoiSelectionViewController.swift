//
//  RoiSelectionViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 11/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit

class RoiSelectionViewController: UIViewController, UIGestureRecognizerDelegate, RoiSelectionContentViewControllerDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionContainer: UIView!
    @IBOutlet weak var currentSelectionButton: RoiSelectionButton!
    @IBOutlet weak var currentTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectionButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var viewResultButton: UIButton!
    
    private var selectionButtons = [RoiSelectionButton]()
    private var pageViewController: UIPageViewController?
    private var viewControllers: [UIViewController]! = [UIViewController]()
    private var titles = [String]()
    private var hasVisitedLastPage: Bool = false
    var selectedInput: SelectionInput!
    var selectedBusinessType: BusinessType!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as? ViewWithBGImage {
            view.setImageBG(selectedBusinessType.backgroundImageName)
        }
        setupDependingOnInput()
        loadPageController()
        
        view.bringSubviewToFront(selectionContainer.superview!)
        view.bringSubviewToFront(nextButton)
        view.bringSubviewToFront(prevButton)
        view.bringSubviewToFront(viewResultButton)
        
        selectionButtons.append(currentSelectionButton)
        currentSelectionButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action:Selector("handleButtonSelect:")))
        currentSelectionButton.fillDot()
        prevButton.hidden = true
        loadSelectionButtons()
        titleLabel.text = titles[0].uppercaseString
    }
    
    private func setupDependingOnInput(){
        
        titles = selectedInput.allTitles()
        
        switch selectedInput {
        case is ROICalculatorInput:
            titles.append(NSLocalizedString("How it plays out for you", comment: ""))
        case is FireSuppressionInput:
            titles.append(NSLocalizedString("RECOMMENDED FIRE SUPPRESSION SYSTEM", comment: ""))
        default:
            break
        }
        
        let widthConstraint = NSLayoutConstraint(item: currentSelectionButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: selectionContainer.superview, attribute: NSLayoutAttribute.Width, multiplier:1/CGFloat(titles.count-1), constant: 0)
        NSLayoutConstraint.deactivateConstraints([selectionButtonWidthConstraint])
        NSLayoutConstraint.activateConstraints([widthConstraint])
    }

    @IBAction func nextAction(sender: UIButton) {
        toggleLeftRight(false)
    }
    @IBAction func prevAction(sender: UIButton) {
        toggleLeftRight(true)
    }
    @IBAction func viewResultAction(sender: UIButton) {
        goToPage(viewControllers.count-1)
    }
    
    private func toggleLeftRight(left: Bool) {
        if let currentController = pageViewController?.viewControllers!.last as? RoiSelectionContentViewController
        {
            let nextIndex = left ? currentController.itemIndex - 1 : currentController.itemIndex + 1
            if viewControllers.count > nextIndex && nextIndex >= 0 {
                let nextController = viewControllers[nextIndex]
                let nextViewControllers: [UIViewController] = [nextController]
                pageViewController?.setViewControllers(nextViewControllers, direction: left ?UIPageViewControllerNavigationDirection.Reverse: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
                if !left {
                    selectionButtons[nextIndex-1].setSelected(nextIndex-1, text: titles[nextIndex-1].uppercaseString)
                }
                if let numberView = currentController.roiContentView {
                    roiValueDidChange(currentController.itemIndex, object: numberView.textView.attributedText!)
                }
                showSelectedInput(nextIndex)
            }
        }
    }
    
    func handleButtonSelect(recognizer: UIGestureRecognizer) {
        if let selectionButton = recognizer.view as? RoiSelectionButton {
            if selectionButton.isSelected(), let index = selectionButtons.indexOf(selectionButton) {
                goToPage(index)
            }
        }
    }
    
    private func goToPage(index: Int) {
        if viewControllers.count > index {
            let nextController = viewControllers[index]
            let nextViewControllers: [UIViewController] = [nextController]
            pageViewController?.setViewControllers(nextViewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
            showSelectedInput(index)
        }
    }
    
    private func loadPageController() {
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("RoiPageController") as! UIPageViewController
        
        for i in 0..<titles.count {
            if let vc = getItemController(i) {
                viewControllers.append(vc)
            }
        }
        let startingViewControllers: [UIViewController] = [viewControllers[0]]
        pageController.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        view.addSubview(pageViewController!.view)

        pageViewController!.didMoveToParentViewController(self)
    }
    
    private func showSelectedInput(itemIndex: Int) {
        
        if selectionButtons.count < itemIndex {
            return
        }
        nextButton.hidden = false
        prevButton.hidden = (itemIndex == 0)

        if hasVisitedLastPage {
            viewResultButton.hidden = false
        }
        currentSelectionButton.unFillDot()
        if(itemIndex < selectionButtons.count) {
            selectionButtons[itemIndex].fillDot()
            currentSelectionButton = selectionButtons[itemIndex]
        }
        else {
            nextButton.hidden = true
            prevButton.hidden = true
            viewResultButton.hidden = true
            hasVisitedLastPage = true
        }
        titleLabel.text = titles[itemIndex].uppercaseString
    }
    
    private func loadSelectionButtons() {
        var currentButton = currentSelectionButton
        for _ in 1...titles.count-2 {
            currentButton = addRoiSelectionButton(currentButton)
        }
    }
    
    private func addRoiSelectionButton(currentButton: RoiSelectionButton) -> RoiSelectionButton {
        let selectionButton = RoiSelectionButton(frame: currentButton.bounds)
        
        let topConstraint = NSLayoutConstraint(item: selectionButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: selectionContainer, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: selectionButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: selectionContainer, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: selectionButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: selectionContainer.superview, attribute: NSLayoutAttribute.Width, multiplier:1/CGFloat(titles.count-1), constant: 0)
        let trailConstraint = NSLayoutConstraint(item: selectionContainer, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: selectionButton, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: currentTrailingConstraint.constant)
        let leadingConstraint = NSLayoutConstraint(item: selectionButton, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: currentButton, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: currentTrailingConstraint.constant)
        
        selectionButton.translatesAutoresizingMaskIntoConstraints = false
        selectionContainer.addSubview(selectionButton)
        
        NSLayoutConstraint.deactivateConstraints([currentTrailingConstraint])
        NSLayoutConstraint.activateConstraints([topConstraint, bottomConstraint, widthConstraint, trailConstraint, leadingConstraint])
        currentTrailingConstraint = trailConstraint
        selectionButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action:Selector("handleButtonSelect:")))
        selectionButtons.append(selectionButton)
        return selectionButton
    }
    

    private func getItemController(itemIndex: Int) -> UIViewController? {
        
        if itemIndex == titles.count-1 {
            if let input = selectedInput as? ROICalculatorInput {
                let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("RoiCalculatorViewController") as! RoiCalculatorViewController
                pageItemController.selectedInput = input
                return pageItemController
            }
        }
        else if itemIndex < titles.count-1 {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("RoiSelectionContentViewController") as! RoiSelectionContentViewController
            pageItemController.itemIndex = itemIndex
            pageItemController.selectedInput = selectedInput
            pageItemController.delegate = self
            return pageItemController
        }
        return nil
    }
    
    func roiValueDidChange(itemIndex: Int, object: AnyObject) {
        if itemIndex < selectionButtons.count {
            let selectedButton = selectionButtons[itemIndex]
            //change to button font size:
            let attString = changeNSAttributedStringFontSize((object as? NSAttributedString)!, fontSize: (selectedButton.button.titleLabel?.font.pointSize)!)
            selectedButton.button.setAttributedTitle(attString, forState: .Normal)
            clearItemsToTheRight(itemIndex)
        }
    }
    
    private func clearItemsToTheRight(itemIndex: Int) {
        if selectedInput is FireSuppressionInput {
            //clear items to the right
            var itemsCleared = false
            for i in itemIndex+1..<selectionButtons.count {
                if selectionButtons[i].isSelected() {
                    selectionButtons[i].setUnSelected()
                }
                if let vc = viewControllers[i] as? RoiSelectionContentViewController, let inputView = vc.roiContentView {
                    inputView.loadNumber(i, selectionInput: vc.selectedInput)
                }
                itemsCleared = true
            }
            if itemsCleared {
                hasVisitedLastPage = false
                viewResultButton.hidden = true
            }
        }
    }
    
    private func changeNSAttributedStringFontSize(attrString: NSAttributedString, fontSize: CGFloat) -> NSAttributedString {
        let mutString : NSMutableAttributedString = NSMutableAttributedString(attributedString: attrString);
        mutString.enumerateAttribute(NSFontAttributeName, inRange: NSMakeRange(0, mutString.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (value, range, stop) -> Void in
            if let oldFont = value as? UIFont {
                let newFont = oldFont.fontWithSize(fontSize)
                mutString.removeAttribute(NSFontAttributeName, range: range)
                mutString.addAttribute(NSFontAttributeName, value: newFont, range: range)
            }
        }
        return mutString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
