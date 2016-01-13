//
//  ContactUsView.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 12/01/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import Foundation
import NibDesignable

protocol ContactUsViewDelegate {
    func showRegionAction()
}

class ContactUsView : NibDesignable {
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    
    var delegate: ContactUsViewDelegate?
    
    @IBAction func phoneAction(sender: AnyObject) {
    }
    @IBAction func emailAction(sender: AnyObject) {
    }
    @IBAction func visitAction(sender: AnyObject) {
    }
    @IBAction func showRegionAction(sender: AnyObject) {
        self.delegate?.showRegionAction()
    }
}