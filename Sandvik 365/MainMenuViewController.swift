//
//  MainMenuViewController.swift
//  Sandvik 365
//
//  Created by Karl Söderström on 05/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation
import UIKit

class MainMenuViewController : UIViewController, VideoButtonDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var firstContainer: UIView!
    @IBOutlet weak var videoButton: VideoButton!
    private var backButtonBg: UIImageView!
    private var showBackButton: Bool = true
    
    override func viewDidLoad() {
        if let navigationController = self.navigationController {
            navigationController.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.translucent = true
            navigationController.navigationBar.tintColor = UIColor.blackColor()
            navigationController.view.backgroundColor = UIColor.clearColor()
            
            backButtonBg = UIImageView(image: UIImage(named: "sandvik_back_btn"))
            navigationController.navigationBar.insertSubview(backButtonBg!, atIndex: 0)
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        }
        videoButton.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkUpdateAvailble", name: JSONManager.updateAvailable, object: nil)
        if NSUserDefaults.standardUserDefaults().objectForKey("firstStart") == nil {
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstStart")
            self.performSegueWithIdentifier("PresentTutorial", sender: self)
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        backButtonBg.hidden = true
        self.navigationController?.navigationBarHidden = true
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.disableLogoButton()
        checkUpdateAvailble()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
        if showBackButton {
            self.backButtonBg.alpha = 0.0
            self.backButtonBg.hidden = false
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.backButtonBg.alpha = 1.0
                }, completion: { (finished: Bool) -> Void in
            })
        }
        showBackButton = true
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.enableLogoButton()
    }
    
    func didTouchEnded() {
        self.performSegueWithIdentifier("VideoViewController", sender: self)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        let point = touch.locationInView(self.firstContainer)
        if CGRectContainsPoint(self.videoButton.frame, point) {
            return false
        }
        return true
    }
    
    func checkUpdateAvailble(){
        if JSONManager().isUpdateAvailable() {
            self.infoButton.setTitle(NSLocalizedString("UPDATE AVAILABLE", comment: ""), forState: .Normal)
        }
        else {
            self.infoButton.setTitle("", forState: .Normal)
        }
    }
    
    @IBAction func showSecondScreen(sender: AnyObject) {
        scrollView.setContentOffset(CGPointMake(0, scrollView.frame.height), animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "VideoViewController" {
            if let vc = segue.destinationViewController as? VideoViewController {
                if let path = NSBundle.mainBundle().pathForResource("Sandvik365_Extern_150917", ofType:"m4v") {
                    vc.videoUrl = NSURL.fileURLWithPath(path)
                }
                showBackButton = false
            }
        }
    }
    
    static func setPartsAndServicesViewController(vc: PartsAndServicesViewController, selectedPartsAndServices: PartsAndServices, navTitle: String?) {
        vc.selectedPartsAndServices = selectedPartsAndServices
        vc.navigationItem.title = navTitle
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}