//
//  RoiCrusherDetailView.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 24/09/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation
import UIKit
import NibDesignable

class RoiCrusherDetailView: NibDesignable {
    
    init(frame: CGRect, input: ROICrusherInput) {
        super.init(frame: frame)
    }

    @IBAction func closeAction(_ sender: AnyObject) {
        if let superview = self.superview {
            self.removeFromSuperview()
            superview.isHidden = true
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
