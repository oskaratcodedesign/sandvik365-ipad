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
    var H125ServiceKit: (pno: String, description: String)?
    var H250ServiceKit: (pno: String, description: String)?
    var H500ServiceKit: (pno: String, description: String)?
    var H1000ServiceKit: (pno: String, description: String)?
    
    fileprivate static var allData: [String: ServiceKitData]?

    init(serialNo: String, dic: NSDictionary){
        self.serialNo = serialNo
        self.model = dic.object(forKey: "Model") as? String
        if let pno = dic.object(forKey: "125H") as? String , !pno.isEmpty, let desc = dic.object(forKey: "125HDescription") as? String {
            self.H125ServiceKit = (pno, desc)
        }
        if let pno = dic.object(forKey: "250H") as? String , !pno.isEmpty, let desc = dic.object(forKey: "250HDescription") as? String {
            self.H250ServiceKit = (pno, desc)
        }
        if let pno = dic.object(forKey: "500H") as? String , !pno.isEmpty, let desc = dic.object(forKey: "500HDescription") as? String {
            self.H500ServiceKit = (pno, desc)
        }
        if let pno = dic.object(forKey: "1000H") as? String , !pno.isEmpty, let desc = dic.object(forKey: "1000HDescription") as? String {
            self.H1000ServiceKit = (pno, desc)
        }
    }
    
    static func getAllData() -> [String: ServiceKitData]? {
        if ServiceKitData.allData != nil && !ServiceKitData.allData!.isEmpty {
            return ServiceKitData.allData
        }
        if let json = JSONManager.readJSONFromFile("servicekit") {
            var allData = [String: ServiceKitData]()
            for obj in json {
                if let sno = obj.object(forKey: "SNo") as? String {
                    allData[sno] = ServiceKitData(serialNo: sno, dic: obj)
                }
            }
            ServiceKitData.allData = allData
        }
        return ServiceKitData.allData
    }
}

class MaintenanceServiceKitData {
    fileprivate static var allData: [String: MaintenanceServiceKitParent]?

    static func getAllData() -> [String: MaintenanceServiceKitParent]? {
        if MaintenanceServiceKitData.allData != nil && !MaintenanceServiceKitData.allData!.isEmpty {
            return MaintenanceServiceKitData.allData
        }
        if let json = JSONManager.readJSONFromFile("maintenancekit") {
            var allData = [String: MaintenanceServiceKitParent]()
            for obj in json {
                if let type = obj.object(forKey: "Parent / Component") as? String {
                    if type == "Parent" {
                        if let sno = obj.object(forKey: "Parent") as? String {
                            allData[sno] = MaintenanceServiceKitParent(serialNo: sno)
                        }
                    }
                    else if type == "Component" {
                        if let sno = obj.object(forKey: "Parent") as? String {
                            if let parent = allData[sno] {
                                parent.components.append(MaintenanceServiceKitComponent(serialNo: sno, dic: obj))
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
}


class MaintenanceServiceKitParent {
    var serialNo: String
    var components: [MaintenanceServiceKitComponent]
    
    init(serialNo: String){
        self.serialNo = serialNo
        self.components = [MaintenanceServiceKitComponent]()
    }
}

class MaintenanceServiceKitComponent {
    var serialNo: String
    var description: String?
    var quantity: Int?
    
    init(serialNo: String, dic: NSDictionary){
        self.serialNo = serialNo
        self.description = dic.object(forKey: "Item Description") as? String
        self.quantity = dic.object(forKey: "Quantity") as? Int
    }
}
