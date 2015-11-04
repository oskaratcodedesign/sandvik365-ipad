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
    
    //let url = NSURL(string: "https://mining.test.ibp.sandvik.com/_layouts/15/Sibp/Services/ServicesHandler.ashx?Client=%7B5525EAB6-6401-4CAA-A5C9-CC8A484638ED%7D")!
    let url = NSBundle.mainBundle().URLForResource("sandvik365", withExtension: "json")!
    
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
                JSONManager.jsonParts = JSONParts(json: data)
                success = true
                print("Finished parsing json")
            }
        }.main {
            completion(success: success)
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

        let parts = JSONParts(json: data)
        
        if let strUrl = data.objectForKey("baseUrl") as? String, let baseUrl = NSURL(string: strUrl) {
            for part in parts.allParts {
                for partService in part.partsServices {
                    for subPartService in partService.subPartsServices {
                        for image in subPartService.content.images {
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
        return path.stringByAppendingFormat("/%@", "data.plist")
    }
}