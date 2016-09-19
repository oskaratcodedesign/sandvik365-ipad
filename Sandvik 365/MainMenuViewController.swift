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
    @IBOutlet weak var scrollViewContentView: UIView!
    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var firstContainer: UIView!
    @IBOutlet weak var videoButton: VideoButton!
    fileprivate var backButtonBg: UIImageView!
    fileprivate var showBackButton: Bool = true
    
    override func viewDidLoad() {
        if let navigationController = self.navigationController {
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.isTranslucent = true
            navigationController.navigationBar.tintColor = UIColor.black
            navigationController.view.backgroundColor = UIColor.clear
            
            backButtonBg = UIImageView(image: UIImage(named: "sandvik_back_btn"))
            navigationController.navigationBar.insertSubview(backButtonBg!, at: 0)
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        videoButton.delegate = self
        if UserDefaults.standard.object(forKey: "firstStart") == nil {
            
            UserDefaults.standard.set(true, forKey: "firstStart")
            self.performSegue(withIdentifier: "PresentTutorial", sender: self)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backButtonBg.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.disableLogoButton()
        checkUpdateAvailble()
        
        NotificationCenter.default.addObserver(self, selector:#selector(checkUpdateAvailble), name: NSNotification.Name(rawValue: JSONManager.updateAvailable), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        self.navigationController?.isNavigationBarHidden = false
        if showBackButton {
            self.backButtonBg.alpha = 0.0
            self.backButtonBg.isHidden = false
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.backButtonBg.alpha = 1.0
                }, completion: { (finished: Bool) -> Void in
            })
        }
        showBackButton = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.enableLogoButton()
    }
    
    func didTouchEnded() {
        self.performSegue(withIdentifier: "VideoViewController", sender: self)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: self.scrollViewContentView)
        if self.videoButton.frame.contains(point) {
            return false
        }
        return true
    }
    
    func checkUpdateAvailble(){
        if JSONManager().isUpdateAvailable() {
            self.infoButton.setTitle(NSLocalizedString("UPDATE AVAILABLE", comment: ""), for: UIControlState())
        }
        else {
            self.infoButton.setTitle("", for: UIControlState())
        }
    }
    
    @IBAction func showSecondScreen(_ sender: AnyObject) {
        scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.frame.height), animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "VideoViewController" {
            if let vc = segue.destination as? VideoViewController {
                if let path = Bundle.main.path(forResource: "Sandvik365_Extern_150917", ofType:"m4v") {
                    vc.videoUrl = URL(fileURLWithPath: path)
                }
                showBackButton = false
            }
        }
        else if segue.identifier == "PartsAndServicesViewController" {
            if let vc = segue.destination as? PartsAndServicesViewController {
                if let json = JSONManager.getData(JSONManager.EndPoint.content_URL) as? PartsAndServicesJSONParts {
                    vc.mainTitle = "PARTS &\nSERVICES"
                    MainMenuViewController.setPartsAndServicesViewController(vc, selectedPartsAndServices: PartsAndServices(businessType: .all, json: json), navTitle: String(format: "%@ | %@", "SANDVIK 365", "PARTS AND SERVICE YOU CAN COUNT ON"))
                }
            }
        }
    }
    
    static func setPartsAndServicesViewController(_ vc: PartsAndServicesViewController, selectedPartsAndServices: PartsAndServices, navTitle: String?) {
        vc.selectedPartsAndServices = selectedPartsAndServices
        vc.navigationItem.title = navTitle
    }
    
}
