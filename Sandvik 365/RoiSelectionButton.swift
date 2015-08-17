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
        UIGraphicsBeginImageContext(bounds.size)
        let font = button.titleLabel!.font
        var paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = .Center
        let textFontAttributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: UIColor(red: 0.082, green:0.678, blue:0.929, alpha:1.000),
            NSParagraphStyleAttributeName: paraStyle
        ]
        
        text.drawInRect(CGRectMake(0, 0, bounds.size.width, bounds.size.height), withAttributes: textFontAttributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        button.setBackgroundImage(image, forState: .Normal)
        //button.setTitle("bla", forState: .Normal)
        
    }

}
