//
//  ContactUsView.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 12/01/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import Foundation
import NibDesignable

class ContactUsView : NibDesignable {
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!

    
    @IBAction func phoneAction(sender: UIButton) {
    }
    @IBAction func emailAction(sender: AnyObject) {
    }
    @IBAction func visitAction(sender: AnyObject) {
    }
    @IBOutlet weak var showRegionsAction: UIButton!
}