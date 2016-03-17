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
    static let updateAvailable = "updateAvailableKey"
    static let newDataAvailable = "newDataAvailableKey"
    static let serviceHandlerImageKey = "serviceHandlerImageKey"
    private let endPoints: [EndPoint] = [.CONTENT_URL, .FIRESUPPRESSION_URL, .CONTACT_US]
    
    enum EndPoint {
        case CONTENT_URL
        case FIRESUPPRESSION_URL
        case CONTACT_US
        
        private static var partsAndServicesJSONParts: PartsAndServicesJSONParts? = nil
        private static var fireSuppressionInput: FireSuppressionInput? = nil
        private static var contactUsData: [RegionData]? = nil
        
        func setDataFromJson(json: NSDictionary) {
            switch self {
            case .CONTENT_URL:
                EndPoint.partsAndServicesJSONParts = PartsAndServicesJSONParts(json: json)
            case .FIRESUPPRESSION_URL:
                EndPoint.fireSuppressionInput = FireSuppressionInput(json: json)
            case .CONTACT_US:
                EndPoint.contactUsData = Region.getAllRegionsWithData(json)
            }
        }
        
        var data: AnyObject? {
            switch self {
            case .CONTENT_URL:
                return EndPoint.partsAndServicesJSONParts
            case .FIRESUPPRESSION_URL:
                return EndPoint.fireSuppressionInput
            case .CONTACT_US:
                return EndPoint.contactUsData
            }
        }
        
        var url: NSURL! {
            switch self {
            case .CONTENT_URL:
                return NSURL(string: "https://mining.sandvik.com/_layouts/15/Sibp/Services/ServicesHandler.ashx?client=5525EAB6-6401-4CAA-A5C9-CC8A484638ED")!
            case .FIRESUPPRESSION_URL:
                return NSURL(string: "https://mining.sandvik.com/_layouts/15/Sibp/Products/FireSuppressionHandler.ashx?client=5525EAB6-6401-4CAA-A5C9-CC8A484638ED")!
            case .CONTACT_US:
                return NSURL(string: "https://mining.sandvik.com/_layouts/15/Sibp/Contact/RegionContactsHandler.ashx?client=5525EAB6-6401-4CAA-A5C9-CC8A484638ED")!
            }
        }
        
        var lastModifiedKey: String! {
            switch self {
            case .CONTENT_URL:
                return "contentLastModified"
            case .FIRESUPPRESSION_URL:
                return "fireLastModified"
            case .CONTACT_US:
                return "contactUsLastModified"
            }
        }
        
        var updateAvailableKey: String! {
            switch self {
            case .CONTENT_URL:
                return "contentUpdateAvailableKey"
            case .FIRESUPPRESSION_URL:
                return "fireUpdateAvailableKey"
            case .CONTACT_US:
                return "contactUsAvailableKey"
            }
        }
        
        var fileName: String! {
            switch self {
            case .CONTENT_URL:
                return "contentData.dat"
            case .FIRESUPPRESSION_URL:
                return "fireData.dat"
            case .CONTACT_US:
                return "contactUs.dat"
            }
        }
        
        func buildUrl() -> NSURL {
            var jsonUrl = self.url
            if let jsonLastModifiedDate = self.jsonLastModifiedDateString(), let components = NSURLComponents(URL: self.url, resolvingAgainstBaseURL: false) {
                var queryItems = [NSURLQueryItem(name: "ifModifiedSince", value: jsonLastModifiedDate)]
                if let oldQueryItems = components.queryItems {
                    queryItems.appendContentsOf(oldQueryItems)
                }
                components.queryItems = queryItems
                if let newUrl = components.URL {
                    jsonUrl = newUrl
                }
            }
            
            return jsonUrl
        }
        
        func cacheFilePath() -> String {
            let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.ApplicationSupportDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
            // Create directory if it does not exist
            do {
                if (!NSFileManager.defaultManager().fileExistsAtPath(path)) {
                    try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
                }
            } catch {
                print("Failed to create Application Support directory.", error)
            }
            
            return path.stringByAppendingFormat("/%@", self.fileName)
        }
        
        func saveUpdateAvailable(updateAvailable: Bool) {
            NSUserDefaults.standardUserDefaults().setBool(updateAvailable, forKey: self.updateAvailableKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        func isUpdateAvailable() -> Bool {
            return NSUserDefaults.standardUserDefaults().boolForKey(self.updateAvailableKey)
        }

        func saveJsonLastModifiedDateString(lastMotified: String) {
            NSUserDefaults.standardUserDefaults().setObject(lastMotified, forKey: self.lastModifiedKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        func jsonLastModifiedDateString() -> String? {
            return NSUserDefaults.standardUserDefaults().stringForKey(self.lastModifiedKey)
        }
        
        func jsonLastModifiedDate() -> NSDate? {
            if let dateString = self.jsonLastModifiedDateString() {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'.'SSSZZZ'Z'"
                return dateFormatter.dateFromString(dateString)
            }
            return nil
        }
    }
    
    static func getData(endPoint: EndPoint) -> AnyObject? {
        if endPoint.data == nil {
            JSONManager().parseJSONFromFileAndSetData(endPoint)
        }
        return endPoint.data
    }
    
    func isUpdateAvailable() -> Bool {
        for endPoint in self.endPoints {
            if endPoint.isUpdateAvailable() {
                return true
            }
        }
        return false
    }
    
    func checkforUpdate(completion: (success: Bool, lastModified: NSDate?) ->()) {
        for endPoint in self.endPoints {
            let url = endPoint.buildUrl()
            NSURLSession.sharedSession().dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                var success = false
                Async.userInitiated {
                    do {
                        if let d = data {
                            if let json = try NSJSONSerialization.JSONObjectWithData(d, options: .MutableContainers) as? NSDictionary {
                                if let status = json.objectForKey("status") as? String {
                                    if status == "success" {
                                        if let message = json.objectForKey("message") as? String {
                                            endPoint.saveUpdateAvailable(false)
                                            print("Received message instead of data: %@, %@", message, endPoint.fileName)
                                        } else if (json.objectForKey("data") as? NSDictionary) != nil {
                                            //update available
                                            endPoint.saveUpdateAvailable(true)
                                            NSNotificationCenter.defaultCenter().postNotificationName(JSONManager.updateAvailable, object: self)
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
                    completion(success: success, lastModified: endPoint.jsonLastModifiedDate())
                }
            }.resume()
        }
    }
    
    func downloadAllJSON(completion: (success: Bool, lastModified: NSDate?, allDownloaded: Bool) ->()) {
        let endpoints = self.endPoints.filter({$0.isUpdateAvailable()})
        var downloadCount = endpoints.count
        for endPoint in endpoints {
            let url = endPoint.buildUrl()
            
            NSURLSession.sharedSession().dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                var success = false
                Async.userInitiated {
                    do {
                        if let d = data {
                            if let json = try NSJSONSerialization.JSONObjectWithData(d, options: .MutableContainers) as? NSDictionary {
                                if let status = json.objectForKey("status") as? String {
                                    if status == "success" {
                                        if let message = json.objectForKey("message") as? String {
                                            print("Received message instead of data: %@, %@", message, endPoint.fileName)
                                        } else if let data = json.objectForKey("data") as? NSDictionary {
                                            self.parseAndHandleJsonAndSetData(data, endpoint: endPoint)
                                            endPoint.saveUpdateAvailable(false)
                                            NSNotificationCenter.defaultCenter().postNotificationName(JSONManager.newDataAvailable, object: self)
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
                        let allDownloaded = (--downloadCount == 0)
                        completion(success: success, lastModified: endPoint.jsonLastModifiedDate(), allDownloaded: allDownloaded)
                }
                }.resume()
        }
    }
    
    func readJSONFromFileAsync(endPoint: EndPoint, completion: (success: Bool) ->()) {
        var success = false
        Async.userInitiated {
            success = self.parseJSONFromFileAndSetData(endPoint)
        }.main {
            completion(success: success)
        }
    }
    
    private func parseJSONFromFileAndSetData(endPoint: EndPoint) -> Bool {
        print("Reading file")
        if let data = NSKeyedUnarchiver.unarchiveObjectWithFile(endPoint.cacheFilePath()) as? NSDictionary {
            print("Parsing json" + endPoint.fileName)
            let start = NSDate()
            endPoint.setDataFromJson(data)
            let end = NSDate()
            print("Time to parse json: %@", end.timeIntervalSinceDate(start))
            print("Finished parsing json")
            return true
        }
        return false
    }
    
    func copyPreloadedFiles() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.ApplicationSupportDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
            if (!NSFileManager.defaultManager().fileExistsAtPath(path)) {
                if let preloadedPath = NSBundle.mainBundle().resourcePath?.stringByAppendingString("/Preloaded Resources") {
                    try NSFileManager.defaultManager().copyItemAtPath(preloadedPath, toPath: path)
                    try NSURL(fileURLWithPath: path).setResourceValue(true, forKey: NSURLIsExcludedFromBackupKey)
                }
            }
        } catch {
            print("Failed to copy preloaded resources")
        }
    }
    
    private func parseAndHandleJsonAndSetData(data: NSDictionary, endpoint: EndPoint) {
        if let lastModified = data.objectForKey("lastModified") as? String {
            endpoint.saveJsonLastModifiedDateString(lastModified)
        }
        
        let path = endpoint.cacheFilePath()
        NSKeyedArchiver.archiveRootObject(data, toFile: path)
        
        do {
            try NSURL(fileURLWithPath: path).setResourceValue(true, forKey: NSURLIsExcludedFromBackupKey)
        } catch {
            print("Failed to exclude json cache file from iCloud backup.", error)
        }
        
        endpoint.setDataFromJson(data)
        
        let endPointData = endpoint.data
        
        if let parts = endPointData as? PartsAndServicesJSONParts {
            if let strUrl = data.objectForKey("baseUrl") as? String, let baseUrl = NSURL(string: strUrl) {
                for part in parts.partsServicesContent {
                    for partService in part.partsServices {
                        if let subPartServices = partService.subPartsServices {
                            for subPartService in subPartServices {
                                for image in subPartService.content.images {
                                    downloadImage(baseUrl, imageUrl: image)
                                }
                            }
                        }
                        else if let content = partService.content {
                            for image in content.images {
                                downloadImage(baseUrl, imageUrl: image)
                            }
                        }
                    }
                }
                /* serviceHandlerImages */
                if let serviceHandlerImages = data.objectForKey("serviceHandlerImages") as? NSDictionary {
                    var scale = UIScreen.mainScreen().scale
                    if scale >= 2 {
                        if UIScreen.mainScreen().bounds.size.height == 1366 || UIScreen.mainScreen().bounds.size.width == 1366 {
                            //ipadpro
                            scale = 3
                        }
                    }
                    for (key, obj) in serviceHandlerImages {
                        if let k = key as? String where (k.rangeOfString("x"+String("scale")) != nil) {
                            if let image = obj.objectForKey("encodedUrl") as? String, let imageUrl = NSURL(string: image) {
                                NSUserDefaults.standardUserDefaults().setURL(imageUrl, forKey: JSONManager.serviceHandlerImageKey)
                                NSUserDefaults.standardUserDefaults().synchronize()
                                downloadImage(baseUrl, imageUrl: imageUrl)
                            }
                        }
                    }
                }
            }
        }
        /* firesuppression images arent used yet else if let parts = endPointData as? FireSuppressionInput {
            if let strUrl = data.objectForKey("baseUrl") as? String, let baseUrl = NSURL(string: strUrl) {
                let allProductGroups = parts.allProductGroups
                for productGroup in allProductGroups {
                    downloadImage(baseUrl, imageUrl: productGroup.image)
                    for eq in productGroup.equipmentTypes {
                        downloadImage(baseUrl, imageUrl: eq.image)
                        for model in eq.models {
                            downloadImage(baseUrl, imageUrl: model.image)
                        }
                    }
                }
            }
        }*/
    }
    
    private func downloadImage(baseUrl: NSURL, imageUrl: NSURL?) {
        if imageUrl != nil {
            do {
                try ImageCache.storeImage(baseUrl, urlPath: imageUrl!)
            } catch {
                print("Failed to download image: %@", imageUrl)
            }
        }
    }
}