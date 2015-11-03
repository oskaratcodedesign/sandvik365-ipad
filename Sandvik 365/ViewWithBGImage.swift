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
    
    func setImageBG(imageName: String) {
        if let image = UIImage(named: imageName) {
            self.imageView.image = image
        }
        if let subview = self.subviews.last {
            self.sendSubviewToBack(subview)
        }
    }
}
