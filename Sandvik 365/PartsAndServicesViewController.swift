//
//  PartsAndServicesViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 25/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit

class PartsAndServicesViewController: UIViewController {

    var selectedPart: Part!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RoiSelectionViewController" {
            if let vc = segue.destinationViewController as? RoiSelectionViewController {
                vc.selectedROICalculator = selectedPart.roiCalculator
                vc.navigationItem.title = String(format: "%@ | %@", self.navigationItem.title!, NSLocalizedString("ROI CALCULATOR", comment: ""))
            }
        }
        else if segue.identifier == "VideoViewController" {
            if let vc = segue.destinationViewController as? VideoViewController {
                vc.selectedPartType = selectedPart.partType
            }
        }
    }

}
