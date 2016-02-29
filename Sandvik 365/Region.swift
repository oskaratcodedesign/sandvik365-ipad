//
//  Region.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 13/01/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import Foundation

enum Region:String {
    case EUROPE = "Europe"
    case NORTH_AMERICA = "North America"
    case SOUTH_AMERICA = "South America"
    case ASIA = "Asia"
    case AFRICA = "Africa"
    case OCEANIA = "Australia/Oceania"
    
    var color: UIColor! {
        switch self {
        case EUROPE:
            return UIColor(red:0.000, green:0.400, blue:0.400, alpha:1.000)
        case NORTH_AMERICA:
            return UIColor(red:1.000, green:0.400, blue:0.000, alpha:1.000)
        case SOUTH_AMERICA:
            return UIColor(red:0.400, green:0.000, blue:0.000, alpha:1.000)
        case ASIA:
            return UIColor(red:1.000, green:0.000, blue:0.400, alpha:1.000)
        case AFRICA:
            return UIColor(red:0.000, green:0.400, blue:1.000, alpha:1.000)
        case OCEANIA:
            return UIColor(red:0.000, green:1.000, blue:0.400, alpha:1.000)
        }
    }
    
    var smallMap: UIImage? {
        switch self {
        case EUROPE:
            return UIImage(named: "world-map-europe")
        case NORTH_AMERICA:
            return UIImage(named: "world-map-northamerica")
        case SOUTH_AMERICA:
            return UIImage(named: "world-map-south-america")
        case ASIA:
            return UIImage(named: "world-map-asia")
        case AFRICA:
            return UIImage(named: "world-map-africa")
        case OCEANIA:
            return UIImage(named: "world-map-oceania")
        }
    }
    
    var bigMap: UIImage? {
        switch self {
        case EUROPE:
            return UIImage(named: "world-map-europe-white")
        case NORTH_AMERICA:
            return UIImage(named: "world-map-northamerica-white")
        case SOUTH_AMERICA:
            return UIImage(named: "world-map-south-america-white")
        case ASIA:
            return UIImage(named: "world-map-asia-white")
        case AFRICA:
            return UIImage(named: "world-map-africa-white")
        case OCEANIA:
            return UIImage(named: "world-map-oceania-white")
        }
    }
    
    func getRegionData(allRegions: [RegionData]) -> RegionData? {
        if let index = allRegions.indexOf({ $0.region == self}) {
            return allRegions[index]
        }
        return nil
    }
    
    
    func setSelectedRegion() {
        NSUserDefaults.standardUserDefaults().setObject(self.rawValue, forKey: "selectedRegion")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    static func selectedRegion(allRegions: [RegionData]) -> Region {
        if let key = NSUserDefaults.standardUserDefaults().objectForKey("selectedRegion") as? String {
            if let region = Region(rawValue: key) {
                return region
            }
        }
        else {
            if let ca = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as? String {
                for region in allRegions {
                    if ((region.countries?.indexOf({ $0.0.caseInsensitiveCompare(ca) == .OrderedSame})) != nil) {
                        return region.region
                    }
                }
            }
            
        }
        return EUROPE
    }
    
    static func getAllRegionsWithData(json: NSDictionary) -> [RegionData] {
        var regionsData: [RegionData] = []
        if let regions = json.objectForKey("regionContacts") as? NSDictionary {
            for region in allRegions {
                if let json = regions.objectForKey(region.rawValue) as? NSDictionary {
                    let regionData = RegionData(region: region, json: json)
                    regionsData.append(regionData)
                }
            }
        }
        return regionsData
    }
    
    static let allRegions = [EUROPE, NORTH_AMERICA, SOUTH_AMERICA, ASIA, AFRICA, OCEANIA]
}

class RegionData {
    let region: Region
    var contactCountry: Country?
    let countries: [String: String]?
    
    init(region: Region, json: NSDictionary){
        self.region = region
        if let contact = json.objectForKey("contact") as? NSDictionary {
            self.contactCountry = Country(json: contact)
        }
        self.countries = json.objectForKey("countries") as? Dictionary
    }
    
    class Country {
        let name: String?
        let phone: String?
        let email: String?
        let countryKey: String?
        let countryName: String?
        let url: String?
        
        init(json: NSDictionary){
            self.name = json.objectForKey("name") as? String
            self.phone = json.objectForKey("phone") as? String
            self.email = json.objectForKey("email") as? String
            self.countryKey = json.objectForKey("countryKey") as? String
            self.countryName = json.objectForKey("countryName") as? String
            self.url = json.objectForKey("url") as? String
        }
    }
    
}