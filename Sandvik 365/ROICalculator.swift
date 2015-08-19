//
//  ROICalculator.swift
//  Sandvik 365
//
//  Created by Karl Söderström on 10/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation

enum ROIService {
    case RampUp
    case ConditionInspection
    case MaintenancePlanning
    case Protective
    
    static let videos = [RampUp : "Sandvik365_Extern_150813"]
    
    func videoURL() -> NSURL? {
        if let videoName = ROIService.videos[self] {
            let path = NSBundle.mainBundle().pathForResource(videoName, ofType:"mp4")
            let url = NSURL.fileURLWithPath(path!)
            return url
        }
        return nil
    }
}

enum ROIProduct {
    case Product1
    case Product2
}

class ROIInput {
    var product: ROIProduct = .Product1
    var numberOfProducts: UInt = 0
    var oreGrade: UInt = 0
    var efficiency: UInt = 0
    var price: UInt = 0
}

class ROICalculator {
    let input: ROIInput
    let services: [ROIService]
    
    init(input: ROIInput, services: [ROIService]) {
        self.input = input
        self.services = services
    }
    
    func originalProfit() -> [UInt] {
        
        // TEMP
        return [0, 0, 0, 1000, 1000, 1000, 1000, 1000, 1000, 1000]
    }
    
    func calculatedProfit() -> [UInt] {
        
        // TEMP
        return [0, 0, 1500, 1500, 1500, 1500, 1500, 1500, 1500, 1500]
    }
}