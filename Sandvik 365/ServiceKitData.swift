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
        MaintenanceServiceKitData.getAllData()
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

class MaintenanceServiceKitData {
    private static var allData: [String: MaintenanceServiceKitData.Parent]?

    static func getAllData() -> [String: MaintenanceServiceKitData.Parent]? {
        if MaintenanceServiceKitData.allData != nil && !MaintenanceServiceKitData.allData!.isEmpty {
            return MaintenanceServiceKitData.allData
        }
        if let json = JSONManager.readJSONFromFile("maintenancekit") {
            var allData = [String: Parent]()
            for obj in json {
                if let type = obj.objectForKey("Parent / Component") as? String {
                    if type == "Parent" {
                        if let sno = obj.objectForKey("Parent") as? String {
                            allData[sno] = Parent(serialNo: sno, dic: obj)
                        }
                    }
                    else if type == "Component" {
                        if let sno = obj.objectForKey("Parent") as? String {
                            if let parent = allData[sno] {
                                parent.components.append(Component(serialNo: sno, dic: obj))
                            } else {
                                print("ERROR component has no parent!")
                            }
                        }
                    }
                }
            }
            MaintenanceServiceKitData.allData = allData
        }
        return MaintenanceServiceKitData.allData
    }
    
    class Parent {
        var serialNo: String
        var description: String?
        var components: [Component]
        
        init(serialNo: String, dic: NSDictionary){
            self.serialNo = serialNo
            self.description = dic.objectForKey("Item Description") as? String
            self.components = [Component]()
        }
    }
    
    class Component {
        var serialNo: String
        var description: String?
        var quantity: Int?
        
        init(serialNo: String, dic: NSDictionary){
            self.serialNo = serialNo
            self.description = dic.objectForKey("Item Description") as? String
            self.quantity = dic.objectForKey("Quantity") as? Int
        }
    }
}