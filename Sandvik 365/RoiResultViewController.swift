//
//  RoiResultViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 22/12/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import UIKit

class RoiResultViewController: UIViewController {

    @IBOutlet weak var seeDetailButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profitLabel: UILabel!
    @IBOutlet weak var detailsContainerView: UIView!
    @IBOutlet weak var graphContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadServiceButtons(buttons: [UIButton]) {
        var size = buttons.first!.bounds.size
        size.width = size.height
        let color = UIColor(red: 0.890, green:0.431, blue:0.153, alpha:1.000)
        for button in buttons {
            let borderimage = CALayer().roundImage(CGRectMake(0, 0, size.width, size.height), fill: false, color: color)
            button.setImage(borderimage, forState: .Normal)
            let fillimage = CALayer().roundImage(CGRectMake(0, 0, size.width, size.height), fill: true, color: color)
            button.setImage(fillimage, forState: .Highlighted)
            button.setImage(fillimage, forState: .Selected)
        }
    }
}
