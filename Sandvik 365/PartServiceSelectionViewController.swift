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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let json = JSONManager().readJSONFromFile() {
            var titles = selectedPartsAndServices.partServiceTitlesAndDescriptions(json, sectionTitle: sectionTitle)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
