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
    var selectedPart: Part!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.moviePlayer = MPMoviePlayerController(contentURL: selectedPart.partType.videoURL())
        if let player = self.moviePlayer {
            player.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            player.view.sizeToFit()
            player.scalingMode = MPMovieScalingMode.Fill
            player.fullscreen = true
            player.controlStyle = MPMovieControlStyle.Fullscreen
            player.movieSourceType = MPMovieSourceType.File
            player.repeatMode = MPMovieRepeatMode.One
            player.play()
            self.view.addSubview(player.view)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "doneButtonClick:", name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
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
