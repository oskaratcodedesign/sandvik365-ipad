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

    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    private func setUp() {
        sectionButton.titleLabel?.textAlignment = .Center
    }
}