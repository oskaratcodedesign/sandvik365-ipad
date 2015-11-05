//
//  PartsAndServicesViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 25/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit

class PartsAndServicesViewController: UIViewController, SelectionWheelDelegate {

    @IBOutlet weak var selectionWheel: SelectionWheel!
    @IBOutlet weak var sectionLabel: UILabel!
    var selectedPartsAndServices: PartsAndServices!
    var selectedSectionTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as? ViewWithBGImage {
            view.setImageBG(self.selectedPartsAndServices.businessType.backgroundImageName)
        }
        selectionWheel.sectionTitles = selectedPartsAndServices.mainSectionTitles()
        selectionWheel.delegate = self
        sectionLabel.text = self.navigationItem.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSelectSection(sectionTitle: String) {
        selectedSectionTitle = sectionTitle
        performSegueWithIdentifier("ShowPartServiceSelectionViewController", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RoiSelectionViewController" {
            if let vc = segue.destinationViewController as? RoiSelectionViewController {
                //vc.selectedROICalculator = selectedPart.roiCalculator
                vc.navigationItem.title = String(format: "%@ | %@", self.navigationItem.title!, NSLocalizedString("ROI CALCULATOR", comment: ""))
            }
        }
        else if segue.identifier == "VideoViewController" {
            if let vc = segue.destinationViewController as? VideoViewController {
                vc.selectedBusinessType = selectedPartsAndServices.businessType
            }
        }
        else if segue.identifier == "ShowPartServiceSelectionViewController" {
            if let vc = segue.destinationViewController as? PartServiceSelectionViewController {
                vc.selectedPartsAndServices = selectedPartsAndServices
                vc.mainSectionTitle = selectedSectionTitle
                vc.navigationItem.title = String(format: "%@ | %@", self.navigationItem.title!, selectedSectionTitle)
            }
        }
    }

}
