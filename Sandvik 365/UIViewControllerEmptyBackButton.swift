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
            let label = UILabel(frame: CGRectMake(0, 0, navController.navigationBar.frame.size.width-navController.navigationBar.frame.size.width/4, navController.navigationBar.frame.size.height))
            if let font = UIFont(name: "AktivGroteskCorpMedium-Regular", size: 16) {
                label.font = font
            }
            label.textColor = UIColor.whiteColor()
            label.text = self.navigationItem.title
            self.navigationItem.titleView = label
        }
    }
}