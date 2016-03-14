//
//  ProductAreaMenuViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 14/03/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import UIKit

class ProductAreaMenuViewController: UIViewController, UIScrollViewDelegate, ProgressLineDelegate, MenuCountOnBoxDelegate  {
    @IBOutlet weak var menuScrollView: UIScrollView!
    @IBOutlet weak var progressView: ProgressLineView!
    @IBOutlet var mainMenuItemViews: [MainMenuItemView]!
    
    @IBOutlet weak var menuCountOnBox: MenuCountOnBox!
    
    override func viewDidLoad() {
        navigationItem.title = String(format: "%@ | %@", "SANDVIK 365", "PARTS AND SERVICES YOU CAN COUNT ON")
        super.viewDidLoad()
        for view in mainMenuItemViews {
            view.button.addTarget(self, action: Selector("pressAction:"), forControlEvents: .TouchUpInside)
        }
        self.scrollViewDidScroll(menuScrollView)
        progressView.delegate = self
        menuCountOnBox.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        menuCountOnBox.loadNewInfo()
    }
    
    func didTapMenuCountOnBox(partsAndServices: PartsAndServices, partService: PartService, subPartService: SubPartService, mainSectionTitle: String) {
        let storyboard = UIStoryboard(name: "PartsAndServices", bundle: nil)
        if let fourth = storyboard.instantiateViewControllerWithIdentifier("SubPartServiceContentViewController") as?SubPartServiceContentViewController {
            
            let menuItem = self.mainMenuItemViews.filter({ $0.partBridgeType.unsignedIntValue == partsAndServices.businessType.rawValue}).first
            let title = menuItem?.label.text
            SubPartServiceSelectionViewController.setSubPartServiceContentViewController(fourth, selectedPartsAndServices: partsAndServices, mainSectionTitle: mainSectionTitle, selectedSectionTitle: partService.title, navTitle: title, selectedSubPart: subPartService)
            
            if let navController = self.navigationController {
                navController.pushViewController(fourth, animated: true)
            }
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
                    if let json = JSONManager.getData(JSONManager.EndPoint.CONTENT_URL) as? PartsAndServicesJSONParts {
                        MainMenuViewController.setPartsAndServicesViewController(vc, selectedPartsAndServices: PartsAndServices(businessType: view.businessType, json: json), navTitle: view.label.text)
                    }
                }
            }
        }
    }
}
