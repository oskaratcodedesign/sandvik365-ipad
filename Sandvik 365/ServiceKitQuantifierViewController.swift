//
//  ServiceKitQuantifier.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 29/08/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import UIKit

class ServiceKitQuantifierViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var pageContentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var introLabel: UILabel!
    var selectedBusinessType: BusinessType!
    
    private var pageViewController: UIPageViewController?
    private var viewControllers: [UIViewController]! = [UIViewController]()
    private var titles = ["Your equipment",
                          "PLEASE ENTER THE NUMBER OF HOURS THAT YOU WANT TO ESTIMATE MAINTENANCE KITS FOR. ALSO ENTER THE WORKING CONDITIONS THAT THE EQUIPMENT WILL RUN IN.",
                          "This is your suggested offer"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as? ViewWithBGImage {
            view.setImageBG(selectedBusinessType.backgroundImageName)
        }
        
        let attrString = NSMutableAttributedString(string: "Welcome\n", attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 25.0)!])
        attrString.appendAttributedString(NSAttributedString(string: "Here is a handy tool that generates personalized recommendations for you. Just enter your data on the following pages and we will do the rest. You can enter data by clicking the up and down arrows, swiping vertically or clicking once to enter data using the keyboard. Navigate to the next screen by clicking the right arrow, and you can always change the data by clicking the options at the bottom.", attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorp-Light", size: 25.0)!]))
        self.introLabel.attributedText = attrString
        configureData(0)
        loadPageController();
        pageContentView.bringSubviewToFront(nextButton)
        pageContentView.bringSubviewToFront(prevButton)
    }
    
    @IBAction func nextAction(sender: UIButton) {
        toggleLeftRight(false)
    }
    @IBAction func prevAction(sender: UIButton) {
        toggleLeftRight(true)
    }
    
    private func configureData(itemIndex: Int) {
        
        if titles.count < itemIndex {
            return
        }
        nextButton.hidden = false
        prevButton.hidden = (itemIndex == 0)
        
        titleLabel.text = titles[itemIndex].uppercaseString
    }
    
    private func toggleLeftRight(left: Bool) {
        if let currentController = pageViewController?.viewControllers!.last
        {
            if let currentIndex = self.viewControllers.indexOf(currentController) {
            let nextIndex = left ? currentIndex - 1 : currentIndex + 1
                if viewControllers.count > nextIndex && nextIndex >= 0 {
                    let nextController = viewControllers[nextIndex]

                    let nextViewControllers: [UIViewController] = [nextController]
                    pageViewController?.setViewControllers(nextViewControllers, direction: left ?UIPageViewControllerNavigationDirection.Reverse: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
                    configureData(nextIndex)
                    if let cv = currentController as? EquipmentViewController, let ncv = nextController as? ExtraEquipmentViewController {
                        ncv.addedServiceKitData = cv.addedServiceKitData
                    }
                }
            }
        }
    }
    
    private func loadPageController() {
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as! UIPageViewController
        
        for i in 0..<titles.count {
            if let vc = getItemController(i) {
                viewControllers.append(vc)
            }
        }
        let startingViewControllers: [UIViewController] = [viewControllers[0]]
        pageController.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        pageContentView.addSubview(pageViewController!.view)
        pageViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints(pageViewController!.view.fillConstraints(pageContentView))
        pageViewController!.didMoveToParentViewController(self)
    }
    
    private func getItemController(itemIndex: Int) -> UIViewController? {
        if(itemIndex < titles.count - 1){
            var pageItemController: UIViewController?
            switch itemIndex {
            case 0:
                pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("EquipmentViewController") as! EquipmentViewController
            case 1:
                pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("ExtraEquipmentViewController") as! ExtraEquipmentViewController
            default: break
                
            }
            //pageItemController.selectedInput = input
            return pageItemController
        }
        return nil
    }
    
    @IBAction func handleTap(sender: AnyObject) {
        if self.scrollView.contentOffset.y < self.scrollView.bounds.size.height {
            self.scrollView.scrollRectToVisible(CGRect(origin: CGPoint(x: 0, y: self.scrollView.bounds.size.height), size: scrollView.bounds.size), animated: true)
        }
    }
}
