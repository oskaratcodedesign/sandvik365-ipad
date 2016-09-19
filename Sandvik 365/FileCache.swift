//
//  FileCache.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 22/04/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import Foundation

class FileCache {
    
    static func clearCache() {
        do {
            let path = try self.cachePath()
            try NSFileManager.defaultManager().removeItemAtPath(path)
        } catch {
            print("Failed to clear \(cacheDir()) cache")
        }
    }
    
    class func cacheDir() -> String! {
        return "files"
    }
    
    static func storeFile(baseUrl: NSURL, urlPath: NSURL) throws {
        let path = try self.pathForUrl(urlPath)
        
        if let url = NSURL(string: urlPath.absoluteString!, relativeToURL: baseUrl) {
            let request = NSURLRequest(URL: url)
            let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            
            data.writeToFile(path, atomically: true)
            try NSURL(fileURLWithPath: path).setResourceValue(true, forKey: NSURLIsExcludedFromBackupKey)
        }
    }
    
    static func getStoredFileURL(urlPath: NSURL) -> NSURL? {
        do {
            let path = try self.pathForUrl(urlPath)
            return NSURL(fileURLWithPath: path)
        } catch {
            return nil
        }
    }
    
    static func pathForUrl(url: NSURL) throws -> String {
        let key = cacheKeyForUrl(url)
        return try pathForCacheKey(key)
    }
    
    private static func cacheKeyForUrl(url: NSURL) -> String {
        var cacheKey = url.absoluteString!.sha1()
        
        // If the URL contains an extension, let's use that one in the cache as well
        if let ext = url.pathExtension {
            cacheKey = cacheKey.stringByAppendingFormat(".%@", ext)
        }
        return cacheKey
    }
    
    private static func pathForCacheKey(cacheKey: String) throws -> String {
        let cachePath = try self.cachePath()
        return cachePath.stringByAppendingFormat("/%@", cacheKey)
    }
    
    private static func cachePath() throws -> String {
        var path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.ApplicationSupportDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        path = path.stringByAppendingFormat("/%@", cacheDir())
        
        // Create directory if it does not exist
        if (!NSFileManager.defaultManager().fileExistsAtPath(path)) {
            try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }
}
