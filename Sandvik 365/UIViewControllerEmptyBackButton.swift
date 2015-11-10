//
//  UIViewControllerEmptyBackButton.swift
//  7Heaven
//
//  Created by Karl Söderström on 13/10/14.
//  Copyright (c) 2014 7Heaven. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    public class func swizzleViewDidLoad() {
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            let originalSelector = Selector("viewDidLoad")
            let swizzledSelector = Selector("mob_viewDidLoad")
            
            let originalMethod : Method = class_getInstanceMethod(self, originalSelector);
            let swizzledMethod : Method = class_getInstanceMethod(self, swizzledSelector);
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    }
    
    func mob_viewDidLoad() {
        self.mob_viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
       
        if let navController = self.navigationController {
            let label = UILabel(frame: CGRectMake(0, 0, navController.navigationBar.frame.size.width-200, navController.navigationBar.frame.size.height))
            label.textAlignment = .Left
            label.textColor = UIColor.whiteColor()
            if let title = self.navigationItem.title {
                let attrString = NSMutableAttributedString(string: title, attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 12)!])
                if let range = title.rangeOfString("| ") {
                    if let lastIndex = range.last {
                        let subTitle = title.substringFromIndex(lastIndex)
                        attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "AktivGroteskCorp-Light", size: 12.0)!, range: NSRange(location: attrString.length-subTitle.characters.count,length: subTitle.characters.count))
                    }
                }
                
                label.attributedText = attrString
            }
            self.navigationItem.titleView = label
        }
    }
}