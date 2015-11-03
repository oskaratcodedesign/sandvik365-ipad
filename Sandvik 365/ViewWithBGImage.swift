//
//  ViewWithBGImage.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 03/11/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import UIKit
import NibDesignable

class ViewWithBGImage: NibDesignable {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var gradientView: GradientView!
    
    @IBInspectable var fillColor: UIColor? {
        didSet {
            self.gradientView.fillColor = fillColor
        }
    }
    
    func setImageBG(imageName: String) {
        if let image = UIImage(named: imageName) {
            self.imageView.image = image
        }
        if let subview = self.subviews.last {
            self.sendSubviewToBack(subview)
        }
    }
}
