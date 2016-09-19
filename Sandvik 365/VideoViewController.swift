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

    fileprivate var moviePlayer : MPMoviePlayerController!
    var videoUrl: URL!
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.hideLogoView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showLogoView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.moviePlayer = MPMoviePlayerController(contentURL: self.videoUrl)
        if let player = self.moviePlayer {
            player.view.translatesAutoresizingMaskIntoConstraints = false
            player.scalingMode = MPMovieScalingMode.aspectFit
            player.isFullscreen = true
            player.controlStyle = MPMovieControlStyle.fullscreen
            player.movieSourceType = MPMovieSourceType.file
            player.repeatMode = MPMovieRepeatMode.none
            player.play()
            self.view.addSubview(player.view)
            NotificationCenter.default.addObserver(self, selector:#selector(doneButtonClick(_:)), name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: nil)
            
            let views = ["player": player.view]
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[player]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[player]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        }
    }
    
    func doneButtonClick(_ sender:Notification?){
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
