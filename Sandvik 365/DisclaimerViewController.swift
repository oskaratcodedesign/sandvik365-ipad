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
    
    @IBOutlet weak var tutorialButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disclaimerTextView.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleNone.rawValue]
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(checkUpdateAvailble), name: JSONManager.updateAvailable, object: nil)
        
        self.tutorialButton.titleLabel!.textAlignment = .Center
        self.updateButton.layer.borderWidth = 2
        self.updateButton.titleLabel!.numberOfLines = 0
        self.updateButton.titleLabel!.textAlignment = .Center
        self.updateButton.setTitle(NSLocalizedString("NEW VERSION AVAILABLE\nUPDATE NOW", comment: ""), forState: .Normal)
        self.updateButton.setTitleColor(Theme.orangePrimaryColor, forState: .Normal)
        self.updateButton.setTitle(NSLocalizedString("NO NEW VERSION AVAILABLE", comment: ""), forState: .Disabled)
        self.updateButton.setTitleColor(UIColor(white:0.600, alpha:0.500), forState: .Disabled)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        checkUpdateAvailble()
    }

    @IBAction func updateAction(sender: UIButton) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.addDownloadingViewAndAnimate()
        JSONManager().downloadAllJSON({ (success, lastModified, allDownloaded) -> () in
            print("downloadJSON. Last modified: %@ allDownloaded %@", lastModified, allDownloaded)
            if allDownloaded {
                appDelegate.removeDownloadingView()
                self.checkUpdateAvailble()
            }
        })
    }
    
    func checkUpdateAvailble(){
        if JSONManager().isUpdateAvailable() {
            self.updateButton.layer.borderColor = Theme.orangePrimaryColor.CGColor
            self.updateButton.enabled = true
        }
        else {
            self.updateButton.layer.borderColor = UIColor(white:0.600, alpha:0.500).CGColor
            self.updateButton.enabled = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PresentTutorial" {
            if let vc = segue.destinationViewController as? TutorialViewController {
                vc.shouldShowCloseButton = true
            }
        }
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
            UIApplication.sharedApplication().openURL(URL)
            return false
    }
    
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
