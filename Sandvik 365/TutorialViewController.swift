//
//  TutorialViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 11/02/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    @IBOutlet weak var pageControl: UIPageControl!
    let imageNames: [String] = ["160210-S365-External-App-tutorial-screen-1",
                                    "160210-S365-External-App-tutorial-screen-2",
                                    "160210-S365-External-App-tutorial-screen-3"]
    
    private var pageViewController: UIPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        createPageViewController()
        setupPageControl()
        self.pageControl.numberOfPages = imageNames.count
        self.view.bringSubviewToFront(self.pageControl)
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
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.clearColor()
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
        
        if itemController.itemIndex+1 < imageNames.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    private func getItemController(itemIndex: Int) -> TutorialContentViewController? {
        
        if itemIndex < imageNames.count {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("TutorialContentViewController") as! TutorialContentViewController
            pageItemController.itemIndex = itemIndex
            pageItemController.imageName = imageNames[itemIndex]
            return pageItemController
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let itemViewController =  pageViewController.viewControllers!.last as! TutorialContentViewController
        self.pageControl.currentPage = itemViewController.itemIndex
    }
}
