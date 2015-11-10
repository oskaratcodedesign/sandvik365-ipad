//
//  MainMenuViewController.swift
//  Sandvik 365
//
//  Created by Karl Söderström on 05/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation
import UIKit

class MainMenuViewController : UIViewController, UIScrollViewDelegate, ProgressLineDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var menuScrollView: UIScrollView!
    @IBOutlet weak var progressView: ProgressLineView!
    @IBOutlet var mainMenuItemViews: [MainMenuItemView]!
    
    private var backButtonBg: UIImageView!
    private var logoImageView: UIImageView?
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
            logoImageView = addLogoToView(navigationController.navigationBar)
        }
        for view in mainMenuItemViews {
            view.button.addTarget(self, action: Selector("pressAction:"), forControlEvents: .TouchUpInside)
        }
        addLogoToView(scrollView)
        self.scrollViewDidScroll(menuScrollView)
        
        progressView.delegate = self
    }
    
    private func addLogoToView(view: UIView) -> UIImageView?
    {
        if let image = UIImage(named: "logo") {
            let logo = UIImageView(image: image)
            let imgWidth:CGFloat = 60
            let topConstraint = NSLayoutConstraint(item: logo, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 25)
            let trailConstraint = NSLayoutConstraint(item: logo, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: -20)
            let widthConstraint = NSLayoutConstraint(item: logo, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: imgWidth)
            let heightConstraint = NSLayoutConstraint(item: logo, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (imgWidth/image.size.width) * image.size.height)
            logo.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(logo)
            NSLayoutConstraint.activateConstraints([topConstraint, trailConstraint, widthConstraint, heightConstraint])
            return logo
        }
        return nil
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        backButtonBg.hidden = true
        if let logo = self.logoImageView {
            logo.hidden = true
        }
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
        if showBackButton {
            if let logo = self.logoImageView {
                logo.alpha = 0.0
                logo.hidden = false
            }
            self.backButtonBg.alpha = 0.0
            self.backButtonBg.hidden = false
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.backButtonBg.alpha = 1.0
                if let logo = self.logoImageView {
                    logo.alpha = 1.0
                }
                }, completion: { (finished: Bool) -> Void in
            })
        }
        showBackButton = true
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
                    if let json = JSONManager.jsonParts {
                        vc.selectedPartsAndServices = PartsAndServices(businessType: view.businessType, json: json)
                        vc.navigationItem.title = view.label.text
                    }
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
                vc.selectedBusinessType = .BulkMaterialHandling
                showBackButton = false
            }
        }
    }
}