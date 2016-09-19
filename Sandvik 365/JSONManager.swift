//
//  JSONDownloader.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 14/10/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation

class JSONManager {
    static let updateAvailable = "updateAvailableKey"
    static let newDataAvailable = "newDataAvailableKey"
    static let serviceHandlerImageKey = "serviceHandlerImageKey"
    fileprivate let endPoints: [EndPoint] = [.content_URL, .firesuppression_URL, .contact_US]
    
    enum EndPoint {
        case content_URL
        case firesuppression_URL
        case contact_US
        
        fileprivate static var partsAndServicesJSONParts: PartsAndServicesJSONParts? = nil
        fileprivate static var fireSuppressionInput: FireSuppressionInput? = nil
        fileprivate static var contactUsData: [RegionData]? = nil
        
        func setDataFromJson(_ json: NSDictionary) {
            switch self {
            case .content_URL:
                EndPoint.partsAndServicesJSONParts = PartsAndServicesJSONParts(json: json)
            case .firesuppression_URL:
                EndPoint.fireSuppressionInput = FireSuppressionInput(json: json)
            case .contact_US:
                EndPoint.contactUsData = Region.getAllRegionsWithData(json)
            }
        }
        
        var data: AnyObject? {
            switch self {
            case .content_URL:
                return EndPoint.partsAndServicesJSONParts
            case .firesuppression_URL:
                return EndPoint.fireSuppressionInput
            case .contact_US:
                return EndPoint.contactUsData as AnyObject?
            }
        }
        
        var url: URL! {
            switch self {
            case .content_URL:
                return URL(string: "https://mining.sandvik.com/_layouts/15/Sibp/Services/ServicesHandler.ashx?client=5525EAB6-6401-4CAA-A5C9-CC8A484638ED")!
            case .firesuppression_URL:
                return URL(string: "https://mining.sandvik.com/_layouts/15/Sibp/Products/FireSuppressionHandler.ashx?client=5525EAB6-6401-4CAA-A5C9-CC8A484638ED")!
            case .contact_US:
                return URL(string: "https://mining.sandvik.com/_layouts/15/Sibp/Contact/RegionContactsHandler.ashx?client=5525EAB6-6401-4CAA-A5C9-CC8A484638ED")!
            }
        }
        
        var lastModifiedKey: String! {
            switch self {
            case .content_URL:
                return "contentLastModified"
            case .firesuppression_URL:
                return "fireLastModified"
            case .contact_US:
                return "contactUsLastModified"
            }
        }
        
        var updateAvailableKey: String! {
            switch self {
            case .content_URL:
                return "contentUpdateAvailableKey"
            case .firesuppression_URL:
                return "fireUpdateAvailableKey"
            case .contact_US:
                return "contactUsAvailableKey"
            }
        }
        
        var fileName: String! {
            switch self {
            case .content_URL:
                return "contentData.dat"
            case .firesuppression_URL:
                return "fireData.dat"
            case .contact_US:
                return "contactUs.dat"
            }
        }
        
        func buildUrl() -> URL {
            var jsonUrl = self.url
            if let jsonLastModifiedDate = self.jsonLastModifiedDateString(), let components = URLComponents(url: self.url, resolvingAgainstBaseURL: false) {
                var queryItems = [URLQueryItem(name: "ifModifiedSince", value: jsonLastModifiedDate)]
                if let oldQueryItems = components.queryItems {
                    queryItems.append(contentsOf: oldQueryItems)
                }
                components.queryItems = queryItems
                if let newUrl = components.url {
                    jsonUrl = newUrl
                }
            }
            
            return jsonUrl!
        }
        
        func cacheFilePath() -> String {
            let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
            // Create directory if it does not exist
            do {
                if (!FileManager.default.fileExists(atPath: path)) {
                    try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                }
            } catch {
                print("Failed to create Application Support directory.", error)
            }
            
            return path.appendingFormat("/%@", self.fileName)
        }
        
        func saveUpdateAvailable(_ updateAvailable: Bool) {
            UserDefaults.standard.set(updateAvailable, forKey: self.updateAvailableKey)
            UserDefaults.standard.synchronize()
        }
        
        func isUpdateAvailable() -> Bool {
            return UserDefaults.standard.bool(forKey: self.updateAvailableKey)
        }

        func saveJsonLastModifiedDateString(_ lastMotified: String) {
            UserDefaults.standard.set(lastMotified, forKey: self.lastModifiedKey)
            UserDefaults.standard.synchronize()
        }
        
        func jsonLastModifiedDateString() -> String? {
            return UserDefaults.standard.string(forKey: self.lastModifiedKey)
        }
        
        func jsonLastModifiedDate() -> Date? {
            if let dateString = self.jsonLastModifiedDateString() {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'.'SSSZZZ'Z'"
                return dateFormatter.date(from: dateString)
            }
            return nil
        }
    }
    
    static func getData(_ endPoint: EndPoint) -> AnyObject? {
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
    
    func checkforUpdate(_ completion: @escaping (_ success: Bool, _ lastModified: Date?) ->()) {
        for endPoint in self.endPoints {
            let url = endPoint.buildUrl()
            URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: NSError?) -> Void in
                var success = false
                
                DispatchQueue.global().async {
                    do {
                        if let d = data {
                            if let json = try JSONSerialization.jsonObject(with: d, options: .mutableContainers) as? NSDictionary {
                                if let status = json.object(forKey: "status") as? String {
                                    if status == "success" {
                                        if let message = json.object(forKey: "message") as? String {
                                            endPoint.saveUpdateAvailable(false)
                                            print("Received message instead of data: %@, %@", message, endPoint.fileName)
                                        } else if (json.object(forKey: "data") as? NSDictionary) != nil {
                                            //update available
                                            endPoint.saveUpdateAvailable(true)
                                            NotificationCenter.default.post(name: Notification.Name(rawValue: JSONManager.updateAvailable), object: self)
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
                    
                    DispatchQueue.main.async {
                        completion(success: success, lastModified: endPoint.jsonLastModifiedDate())
                    }
                }
            } as! (Data?, URLResponse?, Error?) -> Void) .resume()
        }
    }
    
    func downloadAllJSON(_ completion: @escaping (_ success: Bool, _ lastModified: Date?, _ allDownloaded: Bool) ->()) {
        let endpoints = self.endPoints.filter({$0.isUpdateAvailable()})
        var downloadCount = endpoints.count
        for endPoint in endpoints {
            let url = endPoint.buildUrl()
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: NSError?) -> Void in
                var success = false
                DispatchQueue.global().async {
                    do {
                        if let d = data {
                            if let json = try JSONSerialization.jsonObject(with: d, options: .mutableContainers) as? NSDictionary {
                                if let status = json.object(forKey: "status") as? String {
                                    if status == "success" {
                                        if let message = json.object(forKey: "message") as? String {
                                            print("Received message instead of data: %@, %@", message, endPoint.fileName)
                                        } else if let data = json.object(forKey: "data") as? NSDictionary {
                                            self.parseAndHandleJsonAndSetData(data, endpoint: endPoint)
                                            endPoint.saveUpdateAvailable(false)
                                            NotificationCenter.default.post(name: Notification.Name(rawValue: JSONManager.newDataAvailable), object: self)
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
                    DispatchQueue.main.async {
                        downloadCount -= 1
                        let allDownloaded = (downloadCount == 0)
                        completion(success: success, lastModified: endPoint.jsonLastModifiedDate(), allDownloaded: allDownloaded)
                    }
                }
                } as! (Data?, URLResponse?, Error?) -> Void) .resume()
        }
    }
    
    func readJSONFromFileAsync(_ endPoint: EndPoint, completion: @escaping (_ success: Bool) ->()) {
        var success = false
        Async.userInitiated {
            success = self.parseJSONFromFileAndSetData(endPoint)
        }.main {
            completion(success: success)
        }
    }
    
    fileprivate func parseJSONFromFileAndSetData(_ endPoint: EndPoint) -> Bool {
        print("Reading file")
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: endPoint.cacheFilePath()) as? NSDictionary {
            print("Parsing json" + endPoint.fileName)
            let start = Date()
            endPoint.setDataFromJson(data)
            let end = Date()
            print("Time to parse json: %@", end.timeIntervalSince(start))
            print("Finished parsing json")
            return true
        }
        return false
    }
    
    func copyPreloadedFiles() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationSupportDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
            if (!FileManager.default.fileExists(atPath: path)) {
                if let preloadedPath = (Bundle.main.resourcePath)! + "/Preloaded Resources" {
                    try FileManager.default.copyItem(atPath: preloadedPath, toPath: path)
                    try (URL(fileURLWithPath: path) as NSURL).setResourceValue(true, forKey: URLResourceKey.isExcludedFromBackupKey)
                }
            }
        } catch {
            print("Failed to copy preloaded resources")
        }
    }
    
    fileprivate func parseAndHandleJsonAndSetData(_ data: NSDictionary, endpoint: EndPoint) {
        if let lastModified = data.object(forKey: "lastModified") as? String {
            endpoint.saveJsonLastModifiedDateString(lastModified)
        }
        
        let path = endpoint.cacheFilePath()
        NSKeyedArchiver.archiveRootObject(data, toFile: path)
        
        do {
            try (URL(fileURLWithPath: path) as NSURL).setResourceValue(true, forKey: URLResourceKey.isExcludedFromBackupKey)
        } catch {
            print("Failed to exclude json cache file from iCloud backup.", error)
        }
        
        endpoint.setDataFromJson(data)
        
        let endPointData = endpoint.data
        
        if let parts = endPointData as? PartsAndServicesJSONParts {
            if let strUrl = data.object(forKey: "baseUrl") as? String, let baseUrl = URL(string: strUrl) {
                for part in parts.partsServicesContent {
                    for partService in part.partsServices {
                        if let subPartServices = partService.subPartsServices {
                            for subPartService in subPartServices {
                                for image in subPartService.content.images {
                                    downloadImage(baseUrl, imageUrl: image as URL)
                                }
                                for pdf in subPartService.content.pdfs {
                                    downloadFile(baseUrl, imageUrl: pdf.url as URL)
                                }
                            }
                        }
                        else if let content = partService.content {
                            for image in content.images {
                                downloadImage(baseUrl, imageUrl: image as URL)
                            }
                            for pdf in content.pdfs {
                                downloadFile(baseUrl, imageUrl: pdf.url as URL)
                            }
                        }
                    }
                }
                /* serviceHandlerImages */
                if let serviceHandlerImages = data.object(forKey: "serviceHandlerImages") as? NSDictionary {
                    let scale = UIScreen.main.scale
                    for (key, obj) in serviceHandlerImages {
                        if let k = key as? String , k.range(of: "x"+String(Int(scale))) != nil {
                            if let image = (obj as AnyObject).object(forKey: "encodedUrl") as? String, let imageUrl = URL(string: image) {
                                UserDefaults.standard.set(imageUrl, forKey: JSONManager.serviceHandlerImageKey)
                                UserDefaults.standard.synchronize()
                                downloadImage(baseUrl, imageUrl: imageUrl)
                                break
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
    
    fileprivate func downloadFile(_ baseUrl: URL, imageUrl: URL?) {
        if imageUrl != nil {
            do {
                try FileCache.storeFile(baseUrl, urlPath: imageUrl!)
            } catch {
                print("Failed to download image: %@", imageUrl)
            }
        }
    }
    
    fileprivate func downloadImage(_ baseUrl: URL, imageUrl: URL?) {
        if imageUrl != nil {
            do {
                try ImageCache.storeFile(baseUrl, urlPath: imageUrl!)
            } catch {
                print("Failed to download image: %@", imageUrl)
            }
        }
    }
    
    static func readJSONFromFile(_ fileName: String) -> [NSDictionary]? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json")
        {
            if let d = try? Data(contentsOf: URL(fileURLWithPath: path))
            {
                do {
                    if let json = try JSONSerialization.jsonObject(with: d, options: .mutableContainers) as? [NSDictionary] {
                        return json
                    }
                }
                catch {
                    print(error)
                }
            }
        }
        return nil
    }
}
