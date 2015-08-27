//
//  RoiProductView.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 27/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit
import NibDesignable

class RoiProductView: NibDesignable {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func loadProduct(roiInput: ROIInput) {
        setProduct(roiInput, add: 0)
    }
    
    func nextProduct(roiInput: ROIInput)
    {
        setProduct(roiInput, add: 1)
    }
    
    func previousProduct(roiInput: ROIInput)
    {
        setProduct(roiInput, add: -1)
    }
    
    private func setProduct(roiInput: ROIInput, add: Int)
    {
        let index = roiInput.product.rawValue+add
        let product = ROIProduct(rawValue: index) ?? .Product1
        roiInput.product = product
        imageView.image = product.bigProductImage()
    }

}
