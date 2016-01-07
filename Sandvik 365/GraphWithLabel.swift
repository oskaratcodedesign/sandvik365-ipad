//
//  GraphWithLabel.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 06/01/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import Foundation
import UIKit
import NibDesignable

class GraphWithLabel: NibDesignable {

    @IBOutlet weak var graph: UIView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var graphHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!

    func updateHeightAndSetText(multiplier: Double, string: String)
    {
        self.graphHeightConstraint = self.graphHeightConstraint.changeMultiplier(CGFloat(multiplier))
        let newHeight = self.frame.size.height * CGFloat(multiplier)
        self.labelBottomConstraint.constant = 0 
        if newHeight <= label.frame.size.height {
            self.labelBottomConstraint.constant = newHeight
        }
        
        self.label.text = string
    }
    
}