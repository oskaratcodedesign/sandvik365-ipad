//
//  VideoViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 19/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit
import MediaPlayer

class VideoViewController: UIViewController {

    var moviePlayer : MPMoviePlayerController!
    var selectedBusinessType: BusinessType!
    
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.hideLogoView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.showLogoView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.moviePlayer = MPMoviePlayerController(contentURL: selectedBusinessType.videoURL())
        if let player = self.moviePlayer {
            player.view.translatesAutoresizingMaskIntoConstraints = false
            player.scalingMode = MPMovieScalingMode.AspectFit
            player.fullscreen = true
            player.controlStyle = MPMovieControlStyle.Fullscreen
            player.movieSourceType = MPMovieSourceType.File
            player.repeatMode = MPMovieRepeatMode.One
            player.play()
            self.view.addSubview(player.view)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "doneButtonClick:", name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
            
            let views = ["player": player.view]
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[player]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[player]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        }
    }
    
    func doneButtonClick(sender:NSNotification?){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
