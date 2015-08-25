//
//  Parts.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 25/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import Foundation

enum PartType: UInt {
    case None
    case BulkMaterialHandling
    case ConveyorComponents
    case CrusherAndScreening
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