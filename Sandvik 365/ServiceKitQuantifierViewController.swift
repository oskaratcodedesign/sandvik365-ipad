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
    
    fileprivate var pageViewController: UIPageViewController?
    fileprivate var viewControllers: [UIViewController]! = [UIViewController]()
    fileprivate var titles = ["Your equipment",
                          "PLEASE ENTER THE NUMBER OF HOURS THAT YOU WANT TO ESTIMATE MAINTENANCE KITS FOR. ALSO ENTER THE WORKING CONDITIONS THAT THE EQUIPMENT WILL RUN IN.",
                          "This is your suggested offer"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as? ViewWithBGImage {
            view.setImageBG(selectedBusinessType.backgroundImageName)
        }
        
        let attrString = NSMutableAttributedString(string: "Welcome\n", attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 25.0)!])
        attrString.append(NSAttributedString(string: "Here is a handy tool that generates personalized recommendations for you. Just enter your data on the following pages and we will do the rest. You can enter data by clicking the up and down arrows or clicking once to enter data using the keyboard. Navigate to the next screen by clicking the right arrow, and you can always change the data by clicking back / left arrow.", attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorp-Light", size: 25.0)!]))
        self.introLabel.attributedText = attrString
        configureData(0)
        loadPageController();
        pageContentView.bringSubview(toFront: nextButton)
        pageContentView.bringSubview(toFront: prevButton)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        toggleLeftRight(false)
    }
    @IBAction func prevAction(_ sender: UIButton) {
        toggleLeftRight(true)
    }
    
    fileprivate func configureData(_ itemIndex: Int) {
        
        if titles.count < itemIndex {
            return
        }
        nextButton.isHidden = (itemIndex == titles.count - 1)
        prevButton.isHidden = (itemIndex == 0)
        
        titleLabel.text = titles[itemIndex].uppercased()
    }
    
    fileprivate func toggleLeftRight(_ left: Bool) {
        if let currentController = pageViewController?.viewControllers!.last
        {
            if let currentIndex = self.viewControllers.index(of: currentController) {
            let nextIndex = left ? currentIndex - 1 : currentIndex + 1
                if viewControllers.count >= nextIndex && nextIndex >= 0 {
                    let nextController = viewControllers[nextIndex]

                    let nextViewControllers: [UIViewController] = [nextController]
                    pageViewController?.setViewControllers(nextViewControllers, direction: left ?UIPageViewControllerNavigationDirection.reverse: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
                    configureData(nextIndex)
                    if let cv = currentController as? EquipmentViewController, let ncv = nextController as? ExtraEquipmentViewController {
                        ncv.addedServiceKitData = cv.addedServiceKitData
                    }
                    else if let cv = currentController as? ExtraEquipmentViewController, let ncv = nextController as? MaintenanceKitResultViewController {
                        ncv.addedExtraEquipmentData = cv.addedExtraEquipmentData
                    }
                }
            }
        }
    }
    
    fileprivate func loadPageController() {
        let pageController = self.storyboard!.instantiateViewController(withIdentifier: "PageController") as! UIPageViewController
        
        for i in 0..<titles.count {
            if let vc = getItemController(i) {
                viewControllers.append(vc)
            }
        }
        let startingViewControllers: [UIViewController] = [viewControllers[0]]
        pageController.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        pageContentView.addSubview(pageViewController!.view)
        pageViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(pageViewController!.view.fillConstraints(pageContentView))
        pageViewController!.didMove(toParentViewController: self)
    }
    
    fileprivate func getItemController(_ itemIndex: Int) -> UIViewController? {
        if(itemIndex < titles.count){
            var pageItemController: UIViewController?
            switch itemIndex {
            case 0:
                pageItemController = self.storyboard!.instantiateViewController(withIdentifier: "EquipmentViewController") as! EquipmentViewController
            case 1:
                pageItemController = self.storyboard!.instantiateViewController(withIdentifier: "ExtraEquipmentViewController") as! ExtraEquipmentViewController
            case 2:
                pageItemController = self.storyboard!.instantiateViewController(withIdentifier: "MaintenanceKitResultViewController") as! MaintenanceKitResultViewController
            default: break
                
            }
            return pageItemController
        }
        return nil
    }
    
    @IBAction func handleTap(_ sender: AnyObject) {
        if self.scrollView.contentOffset.y < self.scrollView.bounds.size.height {
            self.scrollView.scrollRectToVisible(CGRect(origin: CGPoint(x: 0, y: self.scrollView.bounds.size.height), size: scrollView.bounds.size), animated: true)
        }
    }
}
