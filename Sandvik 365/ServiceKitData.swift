//
//  ServiceKit.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 29/08/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import Foundation

class ServiceKitData {
    var model: String?
    var serialNo: String
    var countryCode: String?
    var H125ServiceKitNo: String?
    var H250ServiceKitNo: String?
    var H500ServiceKitNo: String?
    var H1000ServiceKitNo: String?
    
    private static var allData: [String: ServiceKitData]?

    init(serialNo: String, dic: NSDictionary){
        self.serialNo = serialNo
        self.model = dic.objectForKey("Model") as? String
        self.countryCode = dic.objectForKey("Country") as? String
        self.H125ServiceKitNo = dic.objectForKey("125H") as? String
        self.H250ServiceKitNo = dic.objectForKey("250H") as? String
        self.H500ServiceKitNo = dic.objectForKey("500H") as? String
        self.H1000ServiceKitNo = dic.objectForKey("1000H") as? String
    }
    
    static func getAllData() -> [String: ServiceKitData]? {
        if ServiceKitData.allData != nil && !ServiceKitData.allData!.isEmpty {
            return ServiceKitData.allData
        }
        if let json = JSONManager.readJSONFromFile("servicekit") {
            var allData = [String: ServiceKitData]()
            for obj in json {
                if let sno = obj.objectForKey("SNo") as? String {
                    allData[sno] = ServiceKitData(serialNo: sno, dic: obj)
                }
            }
            ServiceKitData.allData = allData
        }
        return ServiceKitData.allData
    }
}