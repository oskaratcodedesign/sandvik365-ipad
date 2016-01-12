//
//  Video.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 11/01/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import Foundation

class Video {
    var videoUrl: NSURL?
    var title: String
    var imageName: String
    
    init(videoName: String, ext: String, title: String, image: String) {
        if let path = NSBundle.mainBundle().pathForResource(videoName, ofType:ext) {
            self.videoUrl = NSURL.fileURLWithPath(path)
        }
        self.title = title
        self.imageName = image
    }
}