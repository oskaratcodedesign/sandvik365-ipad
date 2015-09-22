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
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    private var selectionButtons = [RoiSelectionButton]()
    private var pageViewController: UIPageViewController?
    private var viewControllers: [UIViewController]! = [UIViewController]()
    private var titles = [String]()
    var selectedROICalculator: ROICalculator!

    override func viewDidLoad() {
        super.viewDidLoad()
        titles = selectedROICalculator.input.allTitles()
        titles.append(NSLocalizedString("How it plays out for you", comment: ""))
        loadPageController()
        let recognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
        recognizer.delegate = self
        view.addGestureRecognizer(recognizer)
        
        view.bringSubviewToFront(selectionContainer)
        selectionButtons.append(currentSelectionButton)
        currentSelectionButton.button.addTarget(self, action: "handleButtonSelect:", forControlEvents: .TouchUpInside)
        currentSelectionButton.setSelected(0, text: titles[0])
        loadSelectionButtons()
        titleLabel.text = titles[0]
    }
    
    func handleTap(recognizer: UIGestureRecognizer) {
        if let currentController = pageViewController?.viewControllers!.last as? RoiSelectionContentViewController
        {
            if viewControllers.count > currentController.itemIndex+1 {
                let nextController = viewControllers[currentController.itemIndex+1]
                let nextViewControllers: [UIViewController] = [nextController]
                pageViewController?.setViewControllers(nextViewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
                showSelectedInput(currentController.itemIndex+1, roiInput: currentController.selectedROICalculator.input)
                if let numberView = currentController.roiContentView as? RoiInputView {
                    roiValueDidChange(currentController.itemIndex, object: numberView.numberLabel.text!)
                }
                titleLabel.text = titles[currentController.itemIndex+1]
            }
        }
    }
    
    func handleButtonSelect(button :UIButton) {
        if let index = selectionButtons.indexOf(button.superview?.superview as! RoiSelectionButton) {
            if viewControllers.count > index {
                let nextController = viewControllers[index]
                let nextViewControllers: [UIViewController] = [nextController]
                pageViewController?.setViewControllers(nextViewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
                currentSelectionButton.unFillDot()
                selectionButtons[index].fillDot()
                currentSelectionButton = selectionButtons[index]
                titleLabel.text = titles[index]
            }
        }
    }
    
    private func loadPageController() {
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("RoiPageController") as! UIPageViewController
        
        for i in 0..<titles.count {
            viewControllers.append(getItemController(i)!)
        }
        let startingViewControllers: [UIViewController] = [viewControllers[0]]
        pageController.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        view.addSubview(pageViewController!.view)

        pageViewController!.didMoveToParentViewController(self)
    }
    
    private func showSelectedInput(itemIndex: Int, roiInput: ROIInput) {
        
        if selectionButtons.count <= itemIndex {
            return
        }
        selectionButtons[itemIndex-1].setSelected(itemIndex-1, text: titles[itemIndex-1])
        selectionButtons[itemIndex].fillDot()
        currentSelectionButton = selectionButtons[itemIndex]
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
        let widthConstraint = NSLayoutConstraint(item: selectionButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.widthConstraint.constant)
        let trailConstraint = NSLayoutConstraint(item: selectionContainer, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: selectionButton, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: currentTrailingConstraint.constant)
        let leadingConstraint = NSLayoutConstraint(item: selectionButton, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: currentButton, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: currentTrailingConstraint.constant)
        
        selectionButton.translatesAutoresizingMaskIntoConstraints = false
        selectionContainer.addSubview(selectionButton)
        
        NSLayoutConstraint.deactivateConstraints([currentTrailingConstraint])
        NSLayoutConstraint.activateConstraints([topConstraint, bottomConstraint, widthConstraint, trailConstraint, leadingConstraint])
        currentTrailingConstraint = trailConstraint
        selectionButton.button.addTarget(self, action: "handleButtonSelect:", forControlEvents: .TouchUpInside)
        selectionButtons.append(selectionButton)
        return selectionButton
    }
    

    private func getItemController(itemIndex: Int) -> UIViewController? {
        
        if itemIndex == titles.count-1 {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("RoiCalculatorViewController") as! RoiCalculatorViewController
            pageItemController.selectedROICalculator = selectedROICalculator
            return pageItemController
        }
        else if itemIndex < titles.count-1 {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("RoiSelectionContentViewController") as! RoiSelectionContentViewController
            pageItemController.itemIndex = itemIndex
            pageItemController.selectedROICalculator = selectedROICalculator
            pageItemController.delegate = self
            return pageItemController
        }
        return nil
    }
    
    func roiValueDidChange(itemIndex: Int, object: AnyObject) {
        if itemIndex < selectionButtons.count {
            let selectedButton = selectionButtons[itemIndex]
            selectedButton.button.setTitle(object as? String, forState: .Normal)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        
        if let currentController = pendingViewControllers.last as? RoiSelectionContentViewController {
            //fillDot(currentController.itemIndex-1)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
