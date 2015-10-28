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
    var sectionTitle: String!
    var selectedSectionTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var titles = selectedPartsAndServices.subPartServicTitles(sectionTitle)
        tempButton.setTitle(titles[0] as! String, forState: .Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func tempAction(sender: UIButton) {
        selectedSectionTitle = sender.titleLabel?.text
        performSegueWithIdentifier("ShowSubPartServiceContentViewController", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowSubPartServiceContentViewController" {
            if let vc = segue.destinationViewController as? SubPartServiceContentViewController {
                vc.selectedPartsAndServices = selectedPartsAndServices
                vc.sectionTitle = selectedSectionTitle
                vc.navigationItem.title = String(format: "%@ | %@", self.navigationItem.title!, selectedSectionTitle)
            }
        }
    }

}
