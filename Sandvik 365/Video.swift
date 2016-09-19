//
//  Video.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 11/01/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import Foundation

enum Videos{
    case get_BUCKET_SHROUD
    case get_CORNER_SHROUD
    case get_MHS_INSTALL
    case get_MHS_REMOVAL
    case get_SECTIONAL_SHROUD
    case rebuilds
    case eclipse
    case rock_DRILL_KITS
    case rock_DRILLS
    case edv_FINAL
    
    var video: Video! {
        switch self {
        case .get_BUCKET_SHROUD:
            return Video(videoName: "GET - Bucket Shroud Wear", ext: "mp4", title: "GET - Bucket Shroud Wear", image: "S365-movie-button-bucket-shroud-wear")
        case .get_CORNER_SHROUD:
            return Video(videoName: "GET - Corner Shroud Installation", ext: "mp4", title: "GET - Corner Shroud Installation", image: "S365-movie-button-corner-shroud-install")
        case .get_MHS_INSTALL:
            return Video(videoName: "GET - MHS Installation", ext: "mp4", title: "GET - MHS Installation", image: "S365-movie-button-MHS-installation")
        case .get_MHS_REMOVAL:
            return Video(videoName: "GET - MHS Removal", ext: "mp4", title: "GET - MHS Removal", image: "S365-movie-button-MHS-deinstallation")
        case .get_SECTIONAL_SHROUD:
            return Video(videoName: "GET - Sectional Shroud Installation", ext: "mp4", title: "GET - Sectional Shroud Installation", image: "S365-movie-button-Sectional-shroud-install")
        case .rebuilds:
            return Video(videoName: "Rebuilds and Major Components", ext: "mp4", title: "Rebuilds and Major Components", image: "rebuilds")
        case .eclipse:
            return Video(videoName: "Eclipse - Fluorine-free fire suppression system", ext: "mp4", title: "Eclipse - Fluorine-free fire suppression system", image: "eclipse")
        case .rock_DRILL_KITS:
            return Video(videoName: "Rock drill kits - Standardize your repairs", ext: "mp4", title: "Rock drill kits - Standardize your repairs", image: "rockdrillkits")
        case .rock_DRILLS:
            return Video(videoName: "Rock drills - Modernize your drilling", ext: "mp4", title: "Rock drills - Modernize your drilling", image: "rockdrill")
        case .edv_FINAL:
            return Video(videoName: "edv_final_160229_1", ext: "mp4", title: "Electric Dump Valve", image: "x1-365-EDV-film")
        }
    }
}

class Video: NSObject {
    var videoName: String!
    var videoUrl: URL?
    var title: String?
    var imageName: String?
    var isFavorite: Bool = false {
        didSet {
            let sd = UserDefaults.standard
            sd.set(isFavorite, forKey: self.videoName)
            sd.synchronize()
        }
    }
    
    init(videoName: String, ext: String, title: String, image: String) {
        if let path = Bundle.main.path(forResource: videoName, ofType:ext) {
            self.videoUrl = URL(fileURLWithPath: path)
        }
        self.videoName = videoName
        self.title = title
        self.imageName = image
        let sd = UserDefaults.standard
        if let isfav = sd.object(forKey: videoName) as? Bool {
            self.isFavorite = isfav
        }
    }

}
