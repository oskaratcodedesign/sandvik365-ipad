//
//  SectionSelectionButton.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 04/11/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation
import NibDesignable

class SectionSelectionButton: NibDesignable {

    @IBOutlet weak var sectionButton: UIButton!
    
    var buttonMultiplierWidth: CGFloat! = 0.0 {
        didSet {
            let widthConstraint = NSLayoutConstraint(item: sectionButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: sectionButton.superview, attribute: NSLayoutAttribute.width, multiplier: buttonMultiplierWidth, constant: 0)
            sectionButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([widthConstraint])
        }
    }

    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    fileprivate func setUp() {
        sectionButton.titleLabel?.textAlignment = .center
    }
}
