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

        if self.selectedPartsAndServices.businessType.roiTitlesLowerCase.contains(sectionTitle.lowercaseString) {
            performSegueWithIdentifier("ShowRoiSelectionViewController", sender: self)
        }
        else if self.selectedPartsAndServices.businessType.mediaCenterTitle?.caseInsensitiveCompare(sectionTitle) == .OrderedSame {
            performSegueWithIdentifier("ShowVideoCenterViewController", sender: self)
        }
        else {
            performSegueWithIdentifier("ShowPartServiceSelectionViewController", sender: self)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPartServiceSelectionViewController" {
            if let vc = segue.destinationViewController as? PartServiceSelectionViewController {
                PartsAndServicesViewController.setPartServiceSelectionViewController(vc, selectedPartsAndServices: selectedPartsAndServices, mainSectionTitle: selectedSectionTitle, navTitle: self.navigationItem.title)
            }
        }
        else if segue.identifier == "ShowVideoCenterViewController" {
            if let vc = segue.destinationViewController as? VideoCenterViewController {
                vc.selectedBusinessType = self.selectedPartsAndServices.businessType
            }
        }
        else if segue.identifier == "ShowRoiSelectionViewController" {
            if let vc = segue.destinationViewController as? RoiSelectionViewController {
                let bType = selectedPartsAndServices.businessType
                if let title = bType.roiCrusherCalculatorTitle where selectedSectionTitle.caseInsensitiveCompare(title) == .OrderedSame {
                    vc.selectedBusinessType = bType
                    vc.selectedInput = bType.roiCrusherInput
                    vc.navigationItem.title = String(format: "%@ | %@", self.navigationItem.title!, title.uppercaseString)
                }
                else if let title = bType.fireSuppressionTitle where selectedSectionTitle.caseInsensitiveCompare(title) == .OrderedSame {
                    vc.selectedBusinessType = bType
                    vc.selectedInput = bType.fireSuppressionInput
                    vc.navigationItem.title = String(format: "%@ | %@", self.navigationItem.title!, title.uppercaseString)
                }
                else if let title = bType.roiGetCalculatorTitle where selectedSectionTitle.caseInsensitiveCompare(title) == .OrderedSame {
                    vc.selectedBusinessType = bType
                    vc.selectedInput = bType.roiGetInput
                    vc.navigationItem.title = String(format: "%@ | %@", self.navigationItem.title!, title.uppercaseString)
                }
            }
        }
    }
    
    static func setPartServiceSelectionViewController(vc: PartServiceSelectionViewController, selectedPartsAndServices: PartsAndServices, mainSectionTitle: String, navTitle: String?) {
        vc.selectedPartsAndServices = selectedPartsAndServices
        vc.mainSectionTitle = mainSectionTitle
        vc.navigationItem.title = navTitle
    }

}
