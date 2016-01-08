//
//  MenuCountOnBox.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 07/01/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import Foundation
import NibDesignable

@IBDesignable class MenuCountOnBox: NibDesignable {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    private var partServices: [PartService]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        getParts()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getParts", name: JSONManager.newDataAvailableKey, object: nil)
    }
    
    func getParts() {
        self.partServices = JSONManager.getJSONParts()?.partsServicesContent.flatMap({ $0.partsServices.filter({ $0.subPartsServices?.filter({ $0.content.contentList.flatMap({ $0 as? Content.CountOnBoxContent}).count > 0}).count > 0})})//filter out those with countonboxes
        loadNewInfo()
    }
    
    func loadNewInfo() {
        if var partServices = self.partServices, let json = JSONManager.getJSONParts() {
            var count = 0
            while count < 1000 {
                //random buisnessType
                let bType = BusinessType.randomBusinessType()
                let ps = PartsAndServices(businessType: bType, json: json)
                partServices = partServices.filter({ ps.shouldPartServiceBeShown($0)})
                let rand = arc4random_uniform(UInt32(partServices.count))
                let partService = partServices[Int(rand)]
                if let subpartServices = partService.subPartsServices?.filter({ps.shouldSubPartServiceBeShown($0)}) {
                    let sub_rand = arc4random_uniform(UInt32(subpartServices.count))
                    let subpartService = subpartServices[Int(sub_rand)]
                    let countonBoxes = subpartService.content.contentList.flatMap(({ $0 as? Content.CountOnBoxContent}))
                    if countonBoxes.count > 0 {
                        let countonBox = countonBoxes[Int(arc4random_uniform(UInt32(countonBoxes.count)))]
                        if let number = countonBox.midText, let botText = countonBox.bottomText {
                            self.numberLabel.text = number
                            self.textLabel.text = botText
                            print("countonBoxes found " + String(count))
                            count = Int.max
                            return
                        }
                    } else { print("countonBoxes not found") }
                }
                else { print("subpartServices not found") }
                count++
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}