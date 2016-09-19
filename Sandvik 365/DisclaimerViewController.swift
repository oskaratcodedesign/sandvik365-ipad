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
        
        disclaimerTextView.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleNone.rawValue]
        NotificationCenter.default.addObserver(self, selector:#selector(checkUpdateAvailble), name: NSNotification.Name(rawValue: JSONManager.updateAvailable), object: nil)
        
        self.tutorialButton.titleLabel!.textAlignment = .center
        self.updateButton.layer.borderWidth = 2
        self.updateButton.titleLabel!.numberOfLines = 0
        self.updateButton.titleLabel!.textAlignment = .center
        self.updateButton.setTitle(NSLocalizedString("NEW VERSION AVAILABLE\nUPDATE NOW", comment: ""), for: UIControlState())
        self.updateButton.setTitleColor(Theme.orangePrimaryColor, for: UIControlState())
        self.updateButton.setTitle(NSLocalizedString("NO NEW VERSION AVAILABLE", comment: ""), for: .disabled)
        self.updateButton.setTitleColor(UIColor(white:0.600, alpha:0.500), for: .disabled)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkUpdateAvailble()
    }

    @IBAction func updateAction(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
            self.updateButton.layer.borderColor = Theme.orangePrimaryColor.cgColor
            self.updateButton.isEnabled = true
        }
        else {
            self.updateButton.layer.borderColor = UIColor(white:0.600, alpha:0.500).cgColor
            self.updateButton.isEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentTutorial" {
            if let vc = segue.destination as? TutorialViewController {
                vc.shouldShowCloseButton = true
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
            UIApplication.shared.openURL(URL)
            return false
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
