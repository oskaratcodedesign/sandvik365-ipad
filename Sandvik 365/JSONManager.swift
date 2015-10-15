//
//  JSONDownloader.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 14/10/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation

class JSONManager {
    
    let url: String = "http://mining.sandvik.com/_layouts/15/Sibp/Services/ServicesHandler.ashx?client=5525EAB6-6401-4CAA-A5C9-CC8A484638ED"
    
    func downLoadJSON() {
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            do {
                if let d = data, let json = try NSJSONSerialization.JSONObjectWithData(d, options: .MutableContainers) as? NSDictionary {
                    print(json)
                }
            }
            catch {
                print(error)
            }
        }.resume()
    }
    
    func readJSONFromFile() {
        
        if let path = NSBundle.mainBundle().pathForResource("sandvik365", ofType: "json")
        {
            if let d = NSData(contentsOfFile: path)
            {
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(d, options: .MutableContainers) as? NSDictionary {
                        print(json)
                    }
                }
                catch {
                    print(error)
                }
            }
        }
        
    }
}