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

    override func viewDidLoad() {
        
        if let navigationController = self.navigationController {
            navigationController.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.translucent = true
            navigationController.navigationBar.tintColor = UIColor.whiteColor()
            navigationController.view.backgroundColor = UIColor.clearColor()
            //navigationController.navigationBar.backIndicatorImage = UIImage(named: "bg")?.imageWithRenderingMode(.AlwaysOriginal)
            //navigationController.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "bg")?.imageWithRenderingMode(.AlwaysOriginal)
/*let image = UIImage(named: "bg")
let button: UIButton = UIButton.buttonWithType(.Custom) as! UIButton
button.frame = CGRectMake(0, 0, image!.size.width, image!.size.height)
button.setImage(image, forState: .Normal)
let backButton = UIBarButtonItem(customView: button)*/
            let backButton = UIBarButtonItem(image: UIImage(named: "bg"), style: .Plain, target: nil, action: nil)
            backButton.imageInsets = UIEdgeInsetsMake(-100, -100, 10, 10)
            //backButton.title = "<"
            backButton.setBackgroundImage(UIImage(named: "bg"), forState: .Normal, barMetrics: .Default)
            //backButton.set
            self.navigationItem.backBarButtonItem = backButton
        }
        self.scrollViewDidScroll(menuScrollView)
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
        if segue.identifier == "RoiRampUp" {
            if let vc = segue.destinationViewController as? RoiSelectionViewController {
                vc.selectedROICalculator = ROICalculator(input: ROIInput(), services: Set<ROIService>())
            }
        }
        else if segue.identifier == "VideoRampUp" {
            if let vc = segue.destinationViewController as? VideoViewController {
                vc.service = ROIService.RampUp
            }
        }
    }
}