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
    
    var backButtonBg: UIImageView!
    
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
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        backButtonBg.hidden = true
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
        self.backButtonBg.alpha = 0.0
        self.backButtonBg.hidden = false
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.backButtonBg.alpha = 1.0
            }, completion: { (finished: Bool) -> Void in
        })
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
                    vc.selectedPart = Part(partType: view.partType, roiCalculator: ROICalculator(input: ROICrusherInput()))
                    vc.navigationItem.title = view.label.text
                }
            }
        }
        else if segue.identifier == "RoiCrusherSelectionViewController" {
            if let vc = segue.destinationViewController as? RoiSelectionViewController {
                vc.selectedROICalculator = ROICalculator(input: ROICrusherInput())
                vc.navigationItem.title = NSLocalizedString("CRUSHER RISK CALCULATOR", comment: "")
            }
        }
        else if segue.identifier == "RoiRockDrillSelectionViewController" {
            if let vc = segue.destinationViewController as? RoiSelectionViewController {
                vc.selectedROICalculator = ROICalculator(input: ROIRockDrillInput())
                vc.navigationItem.title = NSLocalizedString("ROCK DRILL UPGRADE SIMULATOR", comment: "")
            }
        }
        else if segue.identifier == "VideoViewController" {
            if let vc = segue.destinationViewController as? VideoViewController {
                vc.selectedPartType = .BulkMaterialHandling
            }
        }
    }
}