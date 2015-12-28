//
//  RoiGetResultViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 22/12/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import UIKit

class RoiGetResultViewController: RoiResultViewController {

    @IBOutlet var selectionButtons: [UIButton]!
    
    var selectedInput: ROIGetInput!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func selectionAction(sender: UIButton) {
    }
}
