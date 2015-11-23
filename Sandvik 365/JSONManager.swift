//
//  JSONDownloader.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 14/10/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation
import Async

class JSONManager {
    static var jsonParts : JSONParts? = nil
    
    let url = NSURL(string: "http://mining.test.ibp.sandvik.com/_layouts/15/Sibp/Services/ServicesHandler.ashx?Client=%7B5525EAB6-6401-4CAA-A5C9-CC8A484638ED%7D")!
    //let url = NSBundle.mainBundle().URLForResource("sandvik365", withExtension: "json")!
    
    func jsonLastModifiedDate() -> NSDate? {
        if let dateString = self.jsonLastModifiedDateString() {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'.'SSSZZZ'Z'"
            return dateFormatter.dateFromString(dateString)
        } else {
            return nil
        }
    }
    
    func downloadJSON(completion: (success: Bool, lastModified: NSDate?) ->()) {
        let url = self.buildUrl()

        NSURLSession.sharedSession().dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            var success = false
            Async.userInitiated {
                do {
                    if let d = data {
                        if let json = try NSJSONSerialization.JSONObjectWithData(d, options: .MutableContainers) as? NSDictionary {
                            if let status = json.objectForKey("status") as? String {
                                if status == "success" {
                                    if let message = json.objectForKey("message") as? String {
                                        print("Received message instead of data: %@", message)
                                    } else if let data = json.objectForKey("data") as? NSDictionary {
                                        JSONManager.jsonParts = self.parseAndHandleJson(data)
                                    }
                                    success = true
                                }
                            }
                        }
                    }
                }
                catch {
                    print(error)
                }
            }.main {
                completion(success: success, lastModified: self.jsonLastModifiedDate())
            }
        }.resume()
    }
    
    func readJSONFromFile(completion: (success: Bool) ->()) {
        var success = false
        Async.userInitiated {
            print("Reading file")
            if let data = NSDictionary(contentsOfFile: self.cacheFilePath()) {
                print("Parsing json")
                let start = NSDate()
                JSONManager.jsonParts = JSONParts(json: data)
                let end = NSDate()
                print("Time to parse json: %@", end.timeIntervalSinceDate(start))
                success = true
                print("Finished parsing json")
            }
        }.main {
            completion(success: success)
        }
    }
    
    func copyPreloadedFiles() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.ApplicationSupportDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
            if (!NSFileManager.defaultManager().fileExistsAtPath(path)) {
                if let preloadedPath = NSBundle.mainBundle().resourcePath?.stringByAppendingString("/Preloaded Resources") {
                    try NSFileManager.defaultManager().copyItemAtPath(preloadedPath, toPath: path)
                    try NSURL(fileURLWithPath: path).setResourceValue(true, forKey: NSURLIsExcludedFromBackupKey)
                    // FIXME: Temp set last modified
                    self.saveJsonLastModifiedDateString("2015-01-01T00:00:00.0000000Z")
                }
            }
        } catch {
            print("Failed to copy preloaded resources")
        }
    }

    private func buildUrl() -> NSURL {
        var jsonUrl = self.url
        if let jsonLastModifiedDate = self.jsonLastModifiedDateString() {
            if let components = NSURLComponents(URL: self.url, resolvingAgainstBaseURL: false) {
                var queryItems = [NSURLQueryItem(name: "ifModifiedSince", value: jsonLastModifiedDate)]
                if let oldQueryItems = components.queryItems {
                    queryItems.appendContentsOf(oldQueryItems)
                }
                components.queryItems = queryItems
                if let newUrl = components.URL {
                    jsonUrl = newUrl
                }
            }
        }
        return jsonUrl
    }
    
    private func parseAndHandleJson(data: NSDictionary) -> JSONParts {
        if let lastModified = data.objectForKey("lastModified") as? String {
            self.saveJsonLastModifiedDateString(lastModified)
        }
        
        let path = self.cacheFilePath()
        data.writeToFile(path, atomically: true)
        do {
            try NSURL(fileURLWithPath: path).setResourceValue(true, forKey: NSURLIsExcludedFromBackupKey)
        } catch {
            print("Failed to exclude json cache file from iCloud backup.", error)
        }
        

        let parts = JSONParts(json: data)
        
        if let strUrl = data.objectForKey("baseUrl") as? String, let baseUrl = NSURL(string: strUrl) {
            for part in parts.allParts {
                for partService in part.partsServices {
                    if let subPartServices = partService.subPartsServices {
                        for subPartService in subPartServices {
                            for image in subPartService.content.images {
                                do {
                                    try ImageCache.storeImage(baseUrl, urlPath: image)
                                } catch {
                                    print("Failed to download image: %@", image)
                                }
                            }
                        }
                    }
                    else if let content = partService.content {
                        for image in content.images {
                            do {
                                try ImageCache.storeImage(baseUrl, urlPath: image)
                            } catch {
                                print("Failed to download image: %@", image)
                            }
                        }
                    }
                }
                
            }
            
        }
        
        return parts
    }
    
    private func saveJsonLastModifiedDateString(lastMotified: String) {
        NSUserDefaults.standardUserDefaults().setObject(lastMotified, forKey: "jsonLastModified")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private func jsonLastModifiedDateString() -> String? {
        return NSUserDefaults.standardUserDefaults().stringForKey("jsonLastModified")
    }
    
    private func cacheFilePath() -> String {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.ApplicationSupportDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        // Create directory if it does not exist
        do {
            if (!NSFileManager.defaultManager().fileExistsAtPath(path)) {
                try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
            print("Failed to create Application Support directory.", error)
        }
        
        return path.stringByAppendingFormat("/%@", "data.plist")
    }
}