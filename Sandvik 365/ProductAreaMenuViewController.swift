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
        navigationItem.title = String(format: "%@ | %@", "SANDVIK 365", "PARTS AND SERVICE YOU CAN COUNT ON")
        super.viewDidLoad()
        for view in mainMenuItemViews {
            view.button.addTarget(self, action:#selector(pressAction(_:)), for: .touchUpInside)
        }
        self.scrollViewDidScroll(menuScrollView)
        progressView.delegate = self
        menuCountOnBox.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuCountOnBox.loadNewInfo()
    }
    
    func didTapMenuCountOnBox(_ partsAndServices: PartsAndServices, partService: PartService, subPartService: SubPartService, mainSectionTitle: String) {
        let storyboard = UIStoryboard(name: "PartsAndServices", bundle: nil)
        if let fourth = storyboard.instantiateViewController(withIdentifier: "SubPartServiceContentViewController") as?SubPartServiceContentViewController {
            
            let menuItem = self.mainMenuItemViews.filter({ $0.partBridgeType.uint32Value == partsAndServices.businessType.rawValue}).first
            let title = menuItem?.label.text
            SubPartServiceSelectionViewController.setSubPartServiceContentViewController(fourth, selectedPartsAndServices: partsAndServices, mainSectionTitle: mainSectionTitle, selectedSectionTitle: partService.title, navTitle: title, selectedSubPart: subPartService)
            
            if let navController = self.navigationController {
                navController.pushViewController(fourth, animated: true)
            }
        }
    }
    
    func pressAction(_ sender: UIButton) {
        for view in mainMenuItemViews {
            if sender == view.button {
                performSegue(withIdentifier: "PartsAndServicesViewController", sender: view)
                break
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for view in scrollView.subviews {
            if let itemView = view as? MainMenuItemView {
                itemView.updateZoomLevel()
            }
        }
        progressView.progress = scrollView.contentOffset.x /
            (scrollView.contentSize.width - scrollView.frame.width)
    }
    
    func updatedProgress(_ progress: CGFloat) {
        let x = (menuScrollView.contentSize.width - menuScrollView.frame.width) * progress
        menuScrollView.setContentOffset(CGPoint(x: x, y: menuScrollView.contentOffset.y), animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PartsAndServicesViewController" {
            if let vc = segue.destination as? PartsAndServicesViewController {
                if let view = sender as? MainMenuItemView {
                    if let json = JSONManager.getData(JSONManager.EndPoint.content_URL) as? PartsAndServicesJSONParts {
                        MainMenuViewController.setPartsAndServicesViewController(vc, selectedPartsAndServices: PartsAndServices(businessType: view.businessType, json: json), navTitle: view.label.text)
                    }
                }
            }
        }
    }
}
