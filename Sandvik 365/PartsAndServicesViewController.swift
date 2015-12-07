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
        let roiTitle = selectedPartsAndServices.businessType.roiCalculatorTitle
        let fireSuprTitle = selectedPartsAndServices.businessType.fireSuppresionTitle
        if roiTitle != nil && sectionTitle.caseInsensitiveCompare(roiTitle!) == .OrderedSame || fireSuprTitle != nil && sectionTitle.caseInsensitiveCompare(fireSuprTitle!) == .OrderedSame {
            performSegueWithIdentifier("ShowRoiSelectionViewController", sender: self)
        }
        else {
            performSegueWithIdentifier("ShowPartServiceSelectionViewController", sender: self)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "VideoViewController" {
            if let vc = segue.destinationViewController as? VideoViewController {
                vc.selectedBusinessType = selectedPartsAndServices.businessType
            }
        }
        else if segue.identifier == "ShowPartServiceSelectionViewController" {
            if let vc = segue.destinationViewController as? PartServiceSelectionViewController {
                vc.selectedPartsAndServices = selectedPartsAndServices
                vc.mainSectionTitle = selectedSectionTitle
                vc.navigationItem.title = self.navigationItem.title
            }
        }
        else if segue.identifier == "ShowRoiSelectionViewController" {
            if let vc = segue.destinationViewController as? RoiSelectionViewController {
                let roiTitle = selectedPartsAndServices.businessType.roiCalculatorTitle
                let fireSuprTitle = selectedPartsAndServices.businessType.fireSuppresionTitle
                if roiTitle != nil && selectedSectionTitle.caseInsensitiveCompare(roiTitle!) == .OrderedSame {
                    vc.selectedBusinessType = selectedPartsAndServices.businessType
                    vc.selectedInput = self.selectedPartsAndServices.businessType.roiCalculatorInput
                    vc.navigationItem.title = String(format: "%@ | %@", self.navigationItem.title!, roiTitle!.uppercaseString)
                }
                else if fireSuprTitle != nil && selectedSectionTitle.caseInsensitiveCompare(fireSuprTitle!) == .OrderedSame {
                    vc.selectedBusinessType = selectedPartsAndServices.businessType
                    vc.selectedInput = self.selectedPartsAndServices.businessType.fireSuppresionTool
                    vc.navigationItem.title = String(format: "%@ | %@", self.navigationItem.title!, fireSuprTitle!.uppercaseString)
                }
            }
        }
    }

}
