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
                vc.selectedROICalculator = ROICalculator(input: ROIInput(), services: [ROIService.RampUp])
            }
        }
    }
}