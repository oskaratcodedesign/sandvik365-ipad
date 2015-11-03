//
//  ServiceSelectionViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 16/10/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import UIKit

class PartServiceSelectionViewController: UIViewController {

    var selectedPartsAndServices: PartsAndServices!
    var mainSectionTitle: String!
    var selectedSectionTitle: String!
    
    @IBOutlet weak var tempButton: UIButton!
    @IBOutlet weak var tempLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let partsServices = selectedPartsAndServices.partsServices(mainSectionTitle) {
            tempButton.setTitle(partsServices.first?.title, forState: .Normal)
            tempLabel.text = partsServices.first?.description
        }
    }

    @IBAction func tempAction(sender: UIButton) {
        selectedSectionTitle = sender.titleLabel?.text
        performSegueWithIdentifier("ShowSubPartServiceSelectionViewController", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowSubPartServiceSelectionViewController" {
            if let vc = segue.destinationViewController as? SubPartServiceSelectionViewController {
                vc.selectedPartsAndServices = selectedPartsAndServices
                vc.selectedSubPartsServices = selectedPartsAndServices.subPartsServices(mainSectionTitle, partServicesectionTitle: selectedSectionTitle)
                vc.navigationItem.title = String(format: "%@ | %@", self.navigationItem.title!, selectedSectionTitle.uppercaseString)
            }
        }
    }

}
