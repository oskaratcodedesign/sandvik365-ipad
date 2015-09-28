//
//  DisclaimerViewController.swift
//  Sandvik 365
//
//  Created by Max Ehle on 2015-09-28.
//  Copyright © 2015 Commind. All rights reserved.
//

import UIKit

class DisclaimerViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var disclaimerTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disclaimerTextView.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleNone.rawValue]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
            UIApplication.sharedApplication().openURL(URL)
            return false
    }

}
