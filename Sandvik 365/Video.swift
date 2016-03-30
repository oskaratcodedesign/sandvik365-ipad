//
//  Video.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 11/01/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import Foundation

enum Videos{
    case GET_BUCKET_SHROUD
    case GET_CORNER_SHROUD
    case GET_MHS_INSTALL
    case GET_MHS_REMOVAL
    case GET_SECTIONAL_SHROUD
    case REBUILDS
    case ECLIPSE
    case ROCK_DRILL_KITS
    case ROCK_DRILLS
    case EDV_FINAL
    
    var video: Video! {
        switch self {
        case GET_BUCKET_SHROUD:
            return Video(videoName: "GET - Bucket Shroud Wear", ext: "mp4", title: "GET - Bucket Shroud Wear", image: "S365-movie-button-bucket-shroud-wear")
        case GET_CORNER_SHROUD:
            return Video(videoName: "GET - Corner Shroud Installation", ext: "mp4", title: "GET - Corner Shroud Installation", image: "S365-movie-button-corner-shroud-install")
        case GET_MHS_INSTALL:
            return Video(videoName: "GET - MHS Installation", ext: "mp4", title: "GET - MHS Installation", image: "S365-movie-button-MHS-installation")
        case GET_MHS_REMOVAL:
            return Video(videoName: "GET - MHS Removal", ext: "mp4", title: "GET - MHS Removal", image: "S365-movie-button-MHS-deinstallation")
        case GET_SECTIONAL_SHROUD:
            return Video(videoName: "GET - Sectional Shroud Installation", ext: "mp4", title: "GET - Sectional Shroud Installation", image: "S365-movie-button-Sectional-shroud-install")
        case REBUILDS:
            return Video(videoName: "Rebuilds and Major Components", ext: "mp4", title: "Rebuilds and Major Components", image: "rebuilds")
        case ECLIPSE:
            return Video(videoName: "Eclipse - Fluorine-free fire suppression system", ext: "mp4", title: "Eclipse - Fluorine-free fire suppression system", image: "eclipse")
        case ROCK_DRILL_KITS:
            return Video(videoName: "Rock drill kits - Standardize your repairs", ext: "mp4", title: "Rock drill kits - Standardize your repairs", image: "rockdrillkits")
        case ROCK_DRILLS:
            return Video(videoName: "Rock drills - Modernize your drilling", ext: "mp4", title: "Rock drills - Modernize your drilling", image: "rockdrill")
        case EDV_FINAL:
            return Video(videoName: "edv_final_160229_1", ext: "mp4", title: "Electric Dump Valve", image: "x1-365-EDV-film")
        }
    }
}

class Video: NSObject {
    var videoName: String!
    var videoUrl: NSURL?
    var title: String?
    var imageName: String?
    var isFavorite: Bool = false {
        didSet {
            let sd = NSUserDefaults.standardUserDefaults()
            sd.setBool(isFavorite, forKey: self.videoName)
            sd.synchronize()
        }
    }
    
    init(videoName: String, ext: String, title: String, image: String) {
        if let path = NSBundle.mainBundle().pathForResource(videoName, ofType:ext) {
            self.videoUrl = NSURL.fileURLWithPath(path)
        }
        self.videoName = videoName
        self.title = title
        self.imageName = image
        let sd = NSUserDefaults.standardUserDefaults()
        if let isfav = sd.objectForKey(videoName) as? Bool {
            self.isFavorite = isfav
        }
    }

}