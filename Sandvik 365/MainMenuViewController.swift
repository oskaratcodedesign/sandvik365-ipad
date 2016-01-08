//
//  MainMenuViewController.swift
//  Sandvik 365
//
//  Created by Karl Söderström on 05/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation
import UIKit

class MainMenuViewController : UIViewController, UIScrollViewDelegate, ProgressLineDelegate, MenuCountOnBoxDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var menuScrollView: UIScrollView!
    @IBOutlet weak var progressView: ProgressLineView!
    @IBOutlet var mainMenuItemViews: [MainMenuItemView]!
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var menuCountOnBox: MenuCountOnBox!
    
    private var backButtonBg: UIImageView!
    private var showBackButton: Bool = true
    
    override func viewDidLoad() {
        if let navigationController = self.navigationController {
            navigationController.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.translucent = true
            navigationController.navigationBar.tintColor = UIColor.blackColor()
            navigationController.view.backgroundColor = UIColor.clearColor()
            
            backButtonBg = UIImageView(image: UIImage(named: "sandvik_back_btn"))
            navigationController.navigationBar.insertSubview(backButtonBg!, atIndex: 0)
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        }
        for view in mainMenuItemViews {
            view.button.addTarget(self, action: Selector("pressAction:"), forControlEvents: .TouchUpInside)
        }
        self.scrollViewDidScroll(menuScrollView)
        
        progressView.delegate = self
        menuCountOnBox.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkUpdateAvailble", name: JSONManager.updateAvailableKey, object: nil)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        backButtonBg.hidden = true
        self.navigationController?.navigationBarHidden = true
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.disableLogoButton()
        checkUpdateAvailble()
        menuCountOnBox.loadNewInfo()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
        if showBackButton {
            self.backButtonBg.alpha = 0.0
            self.backButtonBg.hidden = false
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.backButtonBg.alpha = 1.0
                }, completion: { (finished: Bool) -> Void in
            })
        }
        showBackButton = true
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.enableLogoButton()
    }
    
    func didTapMenuCountOnBox(partsAndServices: PartsAndServices, partService: PartService, subPartService: SubPartService, mainSectionTitle: String) {
        let storyboard = UIStoryboard(name: "PartsAndServices", bundle: nil)
        if let first = storyboard.instantiateViewControllerWithIdentifier("PartsAndServicesViewController") as?PartsAndServicesViewController, let second = storyboard.instantiateViewControllerWithIdentifier("PartServiceSelectionViewController") as?PartServiceSelectionViewController, let third = storyboard.instantiateViewControllerWithIdentifier("SubPartServiceSelectionViewController") as?SubPartServiceSelectionViewController, let fourth = storyboard.instantiateViewControllerWithIdentifier("SubPartServiceContentViewController") as?SubPartServiceContentViewController {
            
            let menuItem = self.mainMenuItemViews.filter({ $0.partBridgeType.unsignedIntValue == partsAndServices.businessType.rawValue}).first
            let title = menuItem?.label.text
            
            MainMenuViewController.setPartsAndServicesViewController(first, selectedPartsAndServices: partsAndServices, navTitle: title)
            
            PartsAndServicesViewController.setPartServiceSelectionViewController(second, selectedPartsAndServices: partsAndServices, mainSectionTitle: mainSectionTitle, navTitle: title)
            
            PartServiceSelectionViewController.setSubPartServiceSelectionViewController(third, selectedPartsAndServices: partsAndServices, mainSectionTitle: mainSectionTitle, selectedSectionTitle: partService.title, navTitle: title)
            
            SubPartServiceSelectionViewController.setSubPartServiceContentViewController(fourth, selectedPartsAndServices: partsAndServices, mainSectionTitle: mainSectionTitle, selectedSectionTitle: partService.title, navTitle: title, selectedSubPart: subPartService)
            if let navController = self.navigationController {
                
                navController.pushViewController(fourth, animated: true)
                navController.viewControllers.insertContentsOf([first, second, third], at: navController.viewControllers.count - 1)
            }
        }
    }
    
    func checkUpdateAvailble(){
        if JSONManager().isUpdateAvailable() {
            self.infoButton.setTitle(NSLocalizedString("UPDATE AVAILABLE", comment: ""), forState: .Normal)
        }
        else {
            self.infoButton.setTitle("", forState: .Normal)
        }
    }
    
    func pressAction(sender: UIButton) {
        for view in mainMenuItemViews {
            if sender == view.button {
                performSegueWithIdentifier("PartsAndServicesViewController", sender: view)
                break
            }
        }
    }
    
    @IBAction func showSecondScreen(sender: AnyObject) {
        scrollView.setContentOffset(CGPointMake(0, scrollView.frame.height), animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        for view in scrollView.subviews {
            if let itemView = view as? MainMenuItemView {
                itemView.updateZoomLevel()
            }
        }
        progressView.progress = scrollView.contentOffset.x /
            (scrollView.contentSize.width - scrollView.frame.width)
    }
    
    func updatedProgress(progress: CGFloat) {
        let x = (menuScrollView.contentSize.width - menuScrollView.frame.width) * progress
        menuScrollView.setContentOffset(CGPoint(x: x, y: menuScrollView.contentOffset.y), animated: false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PartsAndServicesViewController" {
            if let vc = segue.destinationViewController as? PartsAndServicesViewController {
                if let view = sender as? MainMenuItemView {
                    if let json = JSONManager.getJSONParts() {
                        MainMenuViewController.setPartsAndServicesViewController(vc, selectedPartsAndServices: PartsAndServices(businessType: view.businessType, json: json), navTitle: view.label.text)
                    }
                }
            }
        }
        if segue.identifier == "VideoViewController" {
            if let vc = segue.destinationViewController as? VideoViewController {
                vc.selectedBusinessType = .BulkMaterialHandling
                showBackButton = false
            }
        }
    }
    
    static func setPartsAndServicesViewController(vc: PartsAndServicesViewController, selectedPartsAndServices: PartsAndServices, navTitle: String?) {
        vc.selectedPartsAndServices = selectedPartsAndServices
        vc.navigationItem.title = navTitle
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}