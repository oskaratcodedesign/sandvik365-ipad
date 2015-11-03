//
//  SubServiceViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 16/10/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import UIKit

class SubPartServiceSelectionViewController: UIViewController {

    @IBOutlet weak var tempButton: UIButton!
    var selectedPartsAndServices: PartsAndServices!
    var selectedSubPartsServices: [SubPartService]?
    
    var selectedSubPart: SubPartService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as? ViewWithBGImage {
            view.setImageBG(self.selectedPartsAndServices.businessType.backgroundImageName)
        }
        if let subParts = selectedSubPartsServices {
            tempButton.setTitle(subParts.first?.title, forState: .Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func tempAction(sender: UIButton) {
        if let selectedSectionTitle = sender.titleLabel?.text {
            if let subParts = selectedSubPartsServices {
                for sp in subParts {
                    if sp.title.caseInsensitiveCompare(selectedSectionTitle) == .OrderedSame {
                        selectedSubPart = sp
                        performSegueWithIdentifier("ShowSubPartServiceContentViewController", sender: self)
                        return
                    }
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowSubPartServiceContentViewController" {
            if let vc = segue.destinationViewController as? SubPartServiceContentViewController {
                vc.selectedPartsAndServices = selectedPartsAndServices
                vc.selectedSubPartService = selectedSubPart
                vc.navigationItem.title = self.navigationItem.title
            }
        }
    }

}
