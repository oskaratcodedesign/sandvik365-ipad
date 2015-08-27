//
//  Parts.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 25/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation

enum PartType: UInt {
    case BulkMaterialHandling
    case ConveyorComponents
    case CrusherAndScreening
    case Empty
    
    static let videos = [BulkMaterialHandling : "Sandvik365_Extern_150813"]
    
    func videoURL() -> NSURL? {
        if let videoName = PartType.videos[self] {
            let path = NSBundle.mainBundle().pathForResource(videoName, ofType:"m4v")
            let url = NSURL.fileURLWithPath(path!)
            return url
        }
        return nil
    }
}

class Part {
    let partType: PartType
    let roiCalculator: ROICalculator
    
    init(partType: PartType, roiCalculator: ROICalculator)
    {
        self.partType = partType
        self.roiCalculator = roiCalculator
    }
}