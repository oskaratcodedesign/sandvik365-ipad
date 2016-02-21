//
//  TutorialContentViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 14/02/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import UIKit

class TutorialContentViewController: UIViewController {

    var itemIndex: Int = 0
    var imageName: String?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageName = self.imageName {
            self.imageView.image = UIImage(named: imageName)
        }
    }
}
