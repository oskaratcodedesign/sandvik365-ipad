//
//  RoiSelectionViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 11/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit

class RoiSelectionViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    @IBOutlet var selectionDots: [UIImageView]!
    @IBOutlet weak var titleLabel: UILabel!
    private var pageViewController: UIPageViewController?
    private let numberOfItems = 6;

    var selectedROICalculator: ROICalculator?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPageController()
        setupSelectionDots()
    }
    
    private func loadPageController() {
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("RoiPageController") as! UIPageViewController
        pageController.dataSource = self
        pageController.delegate = self
        
        let firstController = getItemController(0)!
        let startingViewControllers: NSArray = [firstController]
        pageController.setViewControllers(startingViewControllers as [AnyObject], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
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
