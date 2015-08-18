//
//  RoiSelectionButton.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 14/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit
import NibDesignable

class RoiSelectionButton: NibDesignable {

    @IBOutlet weak var button: UIButton!
    
    func setTextAsImage(text: NSString) {
        var size = bounds.size
        UIGraphicsBeginImageContext(size)
        let font = button.titleLabel!.font
        var paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = .Center
        let textFontAttributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: UIColor(red: 0.082, green:0.678, blue:0.929, alpha:1.000),
            NSParagraphStyleAttributeName: paraStyle
        ]
        let textSize = text.sizeWithAttributes(textFontAttributes)
        text.drawInRect(CGRectMake(0, (size.height - textSize.height)/2, size.width, size.height), withAttributes: textFontAttributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        button.setImage(image, forState: .Normal)
    }

}
