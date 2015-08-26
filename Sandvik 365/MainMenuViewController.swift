//
//  MainMenuViewController.swift
//  Sandvik 365
//
//  Created by Karl Söderström on 05/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation
import UIKit

class MainMenuViewController : UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var menuScrollView: UIScrollView!
    @IBOutlet weak var progressView: ProgressLineView!
    @IBOutlet var mainMenuItemViews: [MainMenuItemView]!
    
    var backButtonBg: UIImageView?
    
    override func viewDidLoad() {
        if let navigationController = self.navigationController {
            navigationController.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.translucent = true
            navigationController.navigationBar.tintColor = UIColor.blackColor()
            navigationController.view.backgroundColor = UIColor.clearColor()
            
            //let image = UIImage(named: "sandvik_back_btn")
            backButtonBg = UIImageView(image: UIImage(named: "sandvik_back_btn3"))
            
            let image = UIImage(named: "small_back_arrow")?.imageWithRenderingMode(
                .AlwaysOriginal).imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, 15, 0))
            navigationController.navigationBar.backIndicatorImage = image
            navigationController.navigationBar.backIndicatorTransitionMaskImage = image
            
            //button.frame = CGRectMake(0, 0, image!.size.width, image!.size.height)
            //button.setBackgroundImage(image, forState: .Normal)
            navigationController.navigationBar.insertSubview(backButtonBg!, atIndex: 0)
            //navigationController.navigationItem.backBarButtonItem?.imageInsets = UIEdgeInsetsMake(20, 20, 0, 0)
            let backButton = UIBarButtonItem()
            backButton.title = ""
            self.navigationItem.backBarButtonItem = backButton
        }
        for view in mainMenuItemViews {
            view.button.addTarget(self, action: Selector("pressAction:"), forControlEvents: .TouchUpInside)
        }
        self.scrollViewDidScroll(menuScrollView)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        backButtonBg?.hidden = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        backButtonBg?.hidden = false
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PartsAndServicesViewController" {
            if let vc = segue.destinationViewController as? PartsAndServicesViewController {
                if let view = sender as? MainMenuItemView {
                    vc.selectedPart = Part(partType: view.partType, roiCalculator: ROICalculator(input: ROIInput(), services: Set<ROIService>()))
                }
            }
        }
    }
}