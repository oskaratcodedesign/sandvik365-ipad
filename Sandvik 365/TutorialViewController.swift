//
//  TutorialViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 11/02/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let imageNames: [String] = [
        "S365-Ext-App-tutorial-screen-0-1024x768",
        "S365-Ext-App-tutorial-screen-2-1024x768",
        "S365-Ext-App-tutorial-screen-3-1024x768",
        "S365-Ext-App-tutorial-screen-4-1024x768",
        "S365-Ext-App-tutorial-screen-5-1024x768",
        "S365-Ext-App-tutorial-screen-5b-1024x768",
        "S365-Ext-App-tutorial-screen-6-1024x768",
        "S365-Ext-App-tutorial-screen-7-1024x768",
        "S365-Ext-App-tutorial-screen-8-1024x768",
        "S365-Ext-App-tutorial-screen-9-1024x768",
        "S365-Ext-App-tutorial-screen-11-1024x768"]
    
    private var pageViewController: UIPageViewController?
    var shouldShowCloseButton = false

    override func viewDidLoad() {
        super.viewDidLoad()
        createPageViewController()
        self.pageControl.numberOfPages = imageNames.count
        self.view.bringSubviewToFront(self.pageControl)
        self.view.bringSubviewToFront(self.closeButton)
        if self.shouldShowCloseButton {
            self.closeButton.hidden = false
        }
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.logoButton?.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.logoButton?.hidden = false
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func createPageViewController() {
        
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        pageController.dataSource = self
        pageController.delegate = self
        
        let firstController = getItemController(0)!
        pageController.setViewControllers([firstController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! TutorialContentViewController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! TutorialContentViewController
        
        if itemController.itemIndex+1 <= imageNames.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    private func getItemController(itemIndex: Int) -> TutorialContentViewController? {
        
        if itemIndex <= imageNames.count {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("TutorialContentViewController") as! TutorialContentViewController
            pageItemController.itemIndex = itemIndex
            if itemIndex < imageNames.count {
                pageItemController.imageName = imageNames[itemIndex]
            }
            return pageItemController
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        let itemViewController =  pendingViewControllers.last as! TutorialContentViewController
        if itemViewController.itemIndex == imageNames.count {
            self.pageControl.hidden = true
            self.closeButton.hidden = true
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let itemViewController =  pageViewController.viewControllers!.last as! TutorialContentViewController
        self.pageControl.currentPage = itemViewController.itemIndex
        if itemViewController.itemIndex == imageNames.count {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
}
