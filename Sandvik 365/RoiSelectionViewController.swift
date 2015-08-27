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
    @IBOutlet var selectionDots: [UIImageView]!
    private var selectionButtons = [RoiSelectionButton]()
    private var pageViewController: UIPageViewController?
    private var viewControllers: [UIViewController]! = [UIViewController]()
    
    private let titles = [NSLocalizedString("SELECT PRODUCT", comment: ""),
        NSLocalizedString("NUMBER OF MACHINES", comment: ""),
        NSLocalizedString("ORE GRADE", comment: ""),
        NSLocalizedString("EFFICIENCY", comment: ""),
        NSLocalizedString("ORE PRICE PER TON", comment: ""),
        NSLocalizedString("HOW IT PLAYS OUT FOR YOU", comment: "")]
    
    private let selectionButtonTitles = [NSLocalizedString("PRODUCT", comment: ""),
        NSLocalizedString("NUMBER", comment: ""),
        NSLocalizedString("ORE GRADE", comment: ""),
        NSLocalizedString("EFFICIENCY", comment: ""),
        NSLocalizedString("ORE PRICE/T", comment: "")]

    var selectedROICalculator: ROICalculator!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPageController()
        setupSelectionDots()
        let recognizer = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
        recognizer.delegate = self
        view.addGestureRecognizer(recognizer)
        
        //do not show at first:
        currentSelectionButton.hidden = true
        view.bringSubviewToFront(selectionContainer)
        titleLabel.text = titles[0]
    }
    
    func handleTap(recognizer: UIGestureRecognizer) {
        if let currentController = pageViewController?.viewControllers.last as? RoiSelectionContentViewController
        {
            if viewControllers.count > currentController.itemIndex+1 {
                let nextController = viewControllers[currentController.itemIndex+1]
                let nextViewControllers: NSArray = [nextController]
                pageViewController?.setViewControllers(nextViewControllers as [AnyObject], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
                fillDot(currentController.itemIndex)
                showSelectedInput(currentController.itemIndex, roiInput: currentController.selectedROICalculator.input)
                if let numberView = currentController.roiContentView as? RoiNumberView {
                    roiValueDidChange(currentController.itemIndex, object: numberView.numberLabel.text!)
                }
                titleLabel.text = titles[currentController.itemIndex+1]
            }
        }
    }
    
    

    func handleButtonSelect(button :UIButton) {
        if let index = find(selectionButtons, button.superview?.superview as! RoiSelectionButton) {
            if viewControllers.count > index {
                let nextController = viewControllers[index]
                let nextViewControllers: NSArray = [nextController]
                pageViewController?.setViewControllers(nextViewControllers as [AnyObject], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
                titleLabel.text = titles[index]
            }
        }
    }
    
    private func loadPageController() {
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("RoiPageController") as! UIPageViewController
        
        for i in 0..<titles.count {
            viewControllers.append(getItemController(i)!)
        }
        let startingViewControllers: NSArray = [viewControllers[0]]
        pageController.setViewControllers(startingViewControllers as [AnyObject], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        view.addSubview(pageViewController!.view)

        pageViewController!.didMoveToParentViewController(self)
    }
    
    private func setupSelectionDots() {
        for img in selectionDots{
            img.layer.cornerRadius = img.bounds.width/2
            img.layer.masksToBounds = true
            img.layer.borderColor = UIColor(red: 0.082, green:0.678, blue:0.929, alpha:1.000).CGColor
            img.layer.borderWidth = 1
        }
    }
    
    private func fillDot(itemIndex: Int) {
        if itemIndex >= 0 {
            selectionDots[itemIndex].backgroundColor = UIColor(red: 0.082, green:0.678, blue:0.929, alpha:1.000)
        }
    }
    
    private func showSelectedInput(itemIndex: Int, roiInput: ROIInput) {
        
        if selectionButtons.count > itemIndex {
            return
        }
        
        switch itemIndex {
        case 0:
            let product = roiInput.product
            currentSelectionButton.button.setImage(product.smallProductImage(), forState: .Normal)
            currentSelectionButton.button.addTarget(self, action: "handleButtonSelect:", forControlEvents: .TouchUpInside)
            currentSelectionButton.hidden = false
            addSelectionButtonAndSetTitle(currentSelectionButton)
        case 1:
            let number = roiInput.numberOfProducts
            addRoiSelectionButton(number, itemIndex: itemIndex)
        case 2:
            let number = roiInput.oreGrade
            addRoiSelectionButton(number, itemIndex: itemIndex)
        case 3:
            let number = roiInput.efficiency
            addRoiSelectionButton(number, itemIndex: itemIndex)
        case 4:
            let number = roiInput.price
            addRoiSelectionButton(number, itemIndex: itemIndex)
        default:
            break
        }
    }
    
    private func addRoiSelectionButton(number: UInt, itemIndex: Int)
    {
        let selectionButton = RoiSelectionButton(frame: currentSelectionButton.bounds)
        
        let topConstraint = NSLayoutConstraint(item: selectionButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: selectionContainer, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: selectionButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: selectionContainer, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: selectionButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: self.widthConstraint.constant)
        let trailConstraint = NSLayoutConstraint(item: selectionContainer, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: selectionButton, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: currentTrailingConstraint.constant)
        let leadingConstraint = NSLayoutConstraint(item: selectionButton, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: currentSelectionButton, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: currentTrailingConstraint.constant)
        
        selectionButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        selectionContainer.addSubview(selectionButton)
        
        NSLayoutConstraint.deactivateConstraints([currentTrailingConstraint])
        NSLayoutConstraint.activateConstraints([topConstraint, bottomConstraint, widthConstraint, trailConstraint, leadingConstraint])
        currentSelectionButton = selectionButton
        currentTrailingConstraint = trailConstraint
        selectionButton.button.addTarget(self, action: "handleButtonSelect:", forControlEvents: .TouchUpInside)
        addSelectionButtonAndSetTitle(selectionButton)
    }
    
    private func addSelectionButtonAndSetTitle(button: RoiSelectionButton)
    {
        selectionButtons.append(button)
        button.label.text = selectionButtonTitles[selectionButtons.count-1]
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
        if itemIndex == 0 {
            let selectedButton = selectionButtons[itemIndex]
            if let input = object as? ROIInput {
                selectedButton.button.setImage(input.product.smallProductImage(), forState: .Normal)
            }
        }
        else if itemIndex < selectionButtons.count {
            let selectedButton = selectionButtons[itemIndex]
            selectedButton.button.setTitle(object as? String, forState: .Normal)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        
        if let currentController = pendingViewControllers.last as? RoiSelectionContentViewController {
            fillDot(currentController.itemIndex-1)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
