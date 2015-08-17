//
//  RoiSelectionViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 11/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit

class RoiSelectionViewController: UIViewController, /*UIPageViewControllerDataSource, UIPageViewControllerDelegate,*/ UIGestureRecognizerDelegate {

    @IBOutlet weak var selectionContainer: UIView!
    @IBOutlet weak var currentSelectionButton: RoiSelectionButton!
    @IBOutlet weak var currentTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var selectionDots: [UIImageView]!
    private var selectionButtons = [RoiSelectionButton]()
    private var pageViewController: UIPageViewController?
    private let numberOfItems = 6;

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
    }
    
    func handleTap(recognizer: UIGestureRecognizer) {
        if let currentController = pageViewController?.viewControllers.last as? RoiSelectionContentViewController
        {
            if let nextController = getItemController(currentController.itemIndex+1) {
                let nextViewControllers: NSArray = [nextController]
                pageViewController?.setViewControllers(nextViewControllers as [AnyObject], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
                fillDot(currentController.itemIndex)
                showSelectedInput(currentController.itemIndex, roiInput: currentController.selectedROICalculator.input)
            }
        }
    }
    
    

    func handleButtonSelect(button :UIButton) {
        if let index = find(selectionButtons, button.superview?.superview as! RoiSelectionButton) {
            if let nextController = getItemController(index) {
                let nextViewControllers: NSArray = [nextController]
                pageViewController?.setViewControllers(nextViewControllers as [AnyObject], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
            }
        }
    }
    
    private func loadPageController() {
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("RoiPageController") as! UIPageViewController
        //pageController.dataSource = self
        //pageController.delegate = self
        
        let firstController = getItemController(0)!
        let startingViewControllers: NSArray = [firstController]
        pageController.setViewControllers(startingViewControllers as [AnyObject], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        view.addSubview(pageViewController!.view)

        pageViewController!.didMoveToParentViewController(self)
    }
    
    private func setupSelectionDots() {
        for img in selectionDots{
            img.layer.cornerRadius = img.bounds.width/2
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
            currentSelectionButton.button.addTarget(self, action: "handleButtonSelect:", forControlEvents: .TouchUpInside)
            currentSelectionButton.hidden = false
            selectionButtons.append(currentSelectionButton)
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
        let widthConstraint = NSLayoutConstraint(item: selectionButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 55)
        let trailConstraint = NSLayoutConstraint(item: selectionContainer, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: selectionButton, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: currentTrailingConstraint.constant)
        let leadingConstraint = NSLayoutConstraint(item: selectionButton, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: currentSelectionButton, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: currentTrailingConstraint.constant)
        
        selectionButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        selectionContainer.addSubview(selectionButton)
        
        NSLayoutConstraint.deactivateConstraints([currentTrailingConstraint])
        NSLayoutConstraint.activateConstraints([topConstraint, bottomConstraint, widthConstraint, trailConstraint, leadingConstraint])
        currentSelectionButton = selectionButton
        currentTrailingConstraint = trailConstraint
        selectionButton.button.addTarget(self, action: "handleButtonSelect:", forControlEvents: .TouchUpInside)
        selectionButtons.append(selectionButton)
        
        selectionButton.setTextAsImage(NSString(string: String(number)))
    }

    private func getItemController(itemIndex: Int) -> RoiSelectionContentViewController? {
        
        if itemIndex < numberOfItems {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("RoiSelectionContentViewController") as! RoiSelectionContentViewController
            pageItemController.itemIndex = itemIndex
            pageItemController.selectedROICalculator = selectedROICalculator
            
            return pageItemController
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! RoiSelectionContentViewController
        
        if itemController.itemIndex+1 < numberOfItems {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! RoiSelectionContentViewController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        
        if let currentController = pendingViewControllers.last as? RoiSelectionContentViewController {
            fillDot(currentController.itemIndex-1)
        }
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        
        var count = previousViewControllers.count
        count = 1;
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
