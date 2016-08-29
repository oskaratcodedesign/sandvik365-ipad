//
//  ServiceKitQuantifier.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 29/08/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import UIKit

class ServiceKitQuantifierViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var pageContentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var introLabel: UILabel!
    var selectedBusinessType: BusinessType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as? ViewWithBGImage {
            view.setImageBG(selectedBusinessType.backgroundImageName)
        }
        let attrString = NSMutableAttributedString(string: "Welcome\n", attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorpMedium-Regular", size: 25.0)!])
        attrString.appendAttributedString(NSAttributedString(string: "Here is a handy tool that generates personalized recommendations for you. Just enter your data on the following pages and we will do the rest. You can enter data by clicking the up and down arrows, swiping vertically or clicking once to enter data using the keyboard. Navigate to the next screen by clicking the right arrow, and you can always change the data by clicking the options at the bottom.", attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorp-Light", size: 25.0)!]))
        self.introLabel.attributedText = attrString
        
    }
    
    @IBAction func nextAction(sender: UIButton) {
        //toggleLeftRight(false)
    }
    @IBAction func prevAction(sender: UIButton) {
        //toggleLeftRight(true)
    }
    
    @IBAction func handleTap(sender: AnyObject) {
        if self.scrollView.contentOffset.y < self.scrollView.bounds.size.height {
            self.scrollView.scrollRectToVisible(CGRect(origin: CGPoint(x: 0, y: self.scrollView.bounds.size.height), size: scrollView.bounds.size), animated: true)
        }
    }
}
