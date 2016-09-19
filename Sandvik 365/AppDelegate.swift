//
//  AppDelegate.swift
//  Sandvik 365
//
//  Created by Karl Söderström on 22/07/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var loadingView: LoadingView?
    var downloadingView: DownloadingView?
    var logoButton: UIButton?
    var disclaimerView: Disclaimer?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let jsonManager = JSONManager()
        jsonManager.copyPreloadedFiles()
        jsonManager.checkforUpdate({ (success, lastModified) -> () in
            print("checkforUpdate. Last modified: %@", lastModified)
        })
        
        //always read
        jsonManager.readJSONFromFileAsync(JSONManager.EndPoint.content_URL, completion: { (success) -> () in
            print("read json from file. success = %@", success)
        })
        
        let image = UIImage(named: "sandvik_small_back_arrow")?.resizableImage(withCapInsets: (UIEdgeInsetsMake(0, 24, 0, 0)))
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(image, for: UIControlState(), barMetrics: .default)
        UIBarButtonItem.appearance().setBackButtonBackgroundVerticalPositionAdjustment(15, for: .default)

        UINavigationBar.appearance().setTitleVerticalPositionAdjustment(15, for: .default)

        UIViewController.swizzleViewDidLoad()
        if let window = self.window {
            window.makeKeyAndVisible()
            addLogoToView(window)
            addDisclaimerToView(window)
            showLoadingView()
        }
        
        return true
    }
    
    func addDownloadingViewAndAnimate() {
        if let window = self.window {
            self.downloadingView = DownloadingView(frame: window.bounds)
            if let downloadingView = self.downloadingView {
                window.addSubview(downloadingView)
                downloadingView.activityIndicator.startAnimating()
            }
        }
    }
    
    func removeDownloadingView() {
        if self.downloadingView != nil {
            self.downloadingView!.removeFromSuperview()
            self.downloadingView = nil
        }
    }
    
    fileprivate func addDisclaimerToView(_ view: UIView) {
        self.disclaimerView = Disclaimer(frame: view.bounds)
        view.addSubview(self.disclaimerView!)
    }
    
    fileprivate func addLogoToView(_ view: UIView) -> UIButton?
    {
        if let image = UIImage(named: "SANDVIK-logo-small") {
            self.logoButton = UIButton(type: .custom)
            self.logoButton?.setImage(image, for: UIControlState())
            self.logoButton?.setImage(image, for: .disabled)
            let topConstraint = NSLayoutConstraint(item: self.logoButton!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 25)
            let trailConstraint = NSLayoutConstraint(item: self.logoButton!, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -20)
            self.logoButton!.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(self.logoButton!)
            NSLayoutConstraint.activate([topConstraint, trailConstraint])
            self.logoButton?.addTarget(self, action:#selector(popToRootAction), for: .touchUpInside)
        }
        return self.logoButton
    }

    func hideLogoView() {
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.logoButton?.alpha = 0.0
            self.disclaimerView?.alpha = 0.0
        }) 
    }
    
    func showLogoView() {
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.logoButton?.alpha = 1.0
            self.disclaimerView?.alpha = 1.0
        }) 
    }
    
    func enableLogoButton(){
        self.logoButton?.isEnabled = true
    }
    
    func disableLogoButton(){
        self.logoButton?.isEnabled = false
    }
    
    func popToRootAction() {
        if let navController = self.window?.rootViewController as? UINavigationController {
            navController.popToRootViewController(animated: true)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        addLoadingView()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        JSONManager().checkforUpdate({ (success, lastModified) -> () in
            print("checkforUpdate. Last modified: %@", lastModified)
        })
        showLoadingView()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    fileprivate func showLoadingView () {
        if loadingView == nil {
            addLoadingView()
        }
        
        if let loadingView = self.loadingView {
            loadingView.startLoadingAnimation()
        }
    }
    
    fileprivate func addLoadingView() {
        if let window = self.window {
            for v in window.subviews {
                if v.isKind(of: LoadingView.self) {
                    v.removeFromSuperview()
                }
            }
            loadingView = LoadingView(frame: window.bounds)
            if loadingView != nil {
                window.addSubview(loadingView!)
            }
        }
    }

}

