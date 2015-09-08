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
        setProduct(roiInput, product: roiInput.product)
    }
    
    func nextProduct(roiInput: ROIInput)
    {
        setProduct(roiInput, product: roiInput.product.infiniteNext())
    }
    
    func previousProduct(roiInput: ROIInput)
    {
        setProduct(roiInput, product: roiInput.product.infinitePrevious())
    }
    
    private func setProduct(roiInput: ROIInput, product: ROIProduct)
    {
        roiInput.product = product
        imageView.image = product.bigProductImage()
    }

}
