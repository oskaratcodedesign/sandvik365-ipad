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
    var sectionTitle: String!
    var selectedSectionTitle: String!
    
    @IBOutlet weak var tempButton: UIButton!
    @IBOutlet weak var tempLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var titlesAndDesc = selectedPartsAndServices.partServiceTitlesAndDescriptions(sectionTitle)
        tempButton.setTitle(titlesAndDesc[0].objectForKey("title") as! String, forState: .Normal)
        tempLabel.text = titlesAndDesc[0].objectForKey("description") as! String
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
                vc.sectionTitle = selectedSectionTitle
                vc.navigationItem.title = String(format: "%@ | %@", self.navigationItem.title!, selectedSectionTitle)
            }
        }
    }

}
