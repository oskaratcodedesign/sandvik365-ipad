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
            try FileManager.default.removeItem(atPath: path)
        } catch {
            print("Failed to clear \(cacheDir()) cache")
        }
    }
    
    class func cacheDir() -> String! {
        return "files"
    }
    
    static func storeFile(_ baseUrl: URL, urlPath: URL) throws {
        let path = try self.pathForUrl(urlPath)
        
        if let url = URL(string: urlPath.absoluteString, relativeTo: baseUrl) {
            let request = URLRequest(url: url)
            let data = try NSURLConnection.sendSynchronousRequest(request, returning: nil)
            
            try? data.write(to: URL(fileURLWithPath: path), options: [.atomic])
            try (URL(fileURLWithPath: path) as NSURL).setResourceValue(true, forKey: URLResourceKey.isExcludedFromBackupKey)
        }
    }
    
    static func getStoredFileURL(_ urlPath: URL) -> URL? {
        do {
            let path = try self.pathForUrl(urlPath)
            return URL(fileURLWithPath: path)
        } catch {
            return nil
        }
    }
    
    static func pathForUrl(_ url: URL) throws -> String {
        let key = cacheKeyForUrl(url)
        return try pathForCacheKey(key)
    }
    
    fileprivate static func cacheKeyForUrl(_ url: URL) -> String {
        var cacheKey = url.absoluteString.sha1()
        
        // If the URL contains an extension, let's use that one in the cache as well
        let ext = url.pathExtension
        cacheKey = cacheKey.appendingFormat(".%@", ext)
        return cacheKey
    }
    
    fileprivate static func pathForCacheKey(_ cacheKey: String) throws -> String {
        let cachePath = try self.cachePath()
        return cachePath.appendingFormat("/%@", cacheKey)
    }
    
    fileprivate static func cachePath() throws -> String {
        var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        path = path.appendingFormat("/%@", cacheDir())
        
        // Create directory if it does not exist
        if (!FileManager.default.fileExists(atPath: path)) {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }
}
