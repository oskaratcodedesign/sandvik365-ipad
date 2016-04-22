//
//  ImageCache.swift
//  Sandvik 365
//
//  Created by Karl Söderström on 02/11/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift

class ImageCache : FileCache {
    
    override class func cacheDir() -> String! {
        return "images"
    }
    
    class func getImage(urlPath: NSURL) -> UIImage? {
        do {
            let path = try self.pathForUrl(urlPath)
            return UIImage(contentsOfFile: path)
        } catch {
            return nil
        }
    }
}