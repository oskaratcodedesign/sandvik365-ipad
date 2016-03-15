//
//  PartsServicesMenuViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 14/03/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import UIKit

class PartsServicesMenuViewController: UIViewController, SelectionWheelDelegate {

    @IBOutlet weak var selectionWheel: SelectionWheel!
    override func viewDidLoad() {
        super.viewDidLoad()
        var titles: [String] = ["Interactive tools"]
        if let json = JSONManager.getData(JSONManager.EndPoint.CONTENT_URL) as? PartsAndServicesJSONParts {
            let allPartsAndServices = PartsAndServices(businessType: .All, json: json)
            let partServiceTitles = allPartsAndServices.mainSectionTitles()
            titles += partServiceTitles
        }
        selectionWheel.sectionTitles = titles
        selectionWheel.delegate = self
    }
    
    func didSelectSection(sectionTitle: String) {
        
    }

}
