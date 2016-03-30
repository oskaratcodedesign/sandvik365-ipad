//
//  MenuCountOnBox.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 07/01/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import Foundation
import NibDesignable

protocol MenuCountOnBoxDelegate {
    func didTapMenuCountOnBox(partsAndServices: PartsAndServices, partService: PartService, subPartService: SubPartService, mainSectionTitle: String)
}

@IBDesignable class MenuCountOnBox: NibDesignable {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    var delegate: MenuCountOnBoxDelegate?
    
    private var partsAndServices: PartsAndServices?
    private var mainSectiontTile: String?
    private var partService: PartService?
    private var subPartService: SubPartService?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        getParts()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(getParts), name: JSONManager.newDataAvailable, object: nil)
    }
    
    func getParts() {
        if let json = JSONManager.getData(JSONManager.EndPoint.CONTENT_URL) as? PartsAndServicesJSONParts {
            //find first
            var count = 0
            while count < 1000 {
                let bType = BusinessType.randomBusinessType()
                let partsAndServices = PartsAndServices(businessType: bType, json: json)
                
                for pc in json.partsServicesContent  {
                    for ps in pc.partsServices {
                        if partsAndServices.shouldPartServiceBeShown(ps), let subPartServices = ps.subPartsServices?.filter({partsAndServices.shouldSubPartServiceBeShown($0)}) where subPartServices.count > 0 {
                            for sp in subPartServices {
                                let countOnBoxes = sp.content.contentList.flatMap({ $0 as? Content.CountOnBoxContent})
                                if let countonBox = countOnBoxes.first {
                                    if let number = countonBox.midText, let botText = countonBox.bottomText {
                                        self.numberLabel.text = number
                                        self.textLabel.text = botText
                                        self.partsAndServices = partsAndServices
                                        self.partService = ps
                                        self.subPartService = sp
                                        self.mainSectiontTile = pc.title
                                        print("first countonBox found " + String(count))
                                        count = Int.max
                                        return
                                    }
                                }
                            }
                        }
                    }
                }
                count += 1
            }
        }
        loadNewInfo()
    }
    
    func loadNewInfo() {
        if let json = JSONManager.getData(JSONManager.EndPoint.CONTENT_URL) as? PartsAndServicesJSONParts {
            var count = 0
            while count < 1000 {
                //random buisnessType
                let bType = BusinessType.randomBusinessType()
                let ps = PartsAndServices(businessType: bType, json: json)
                let partServiceContent = json.partsServicesContent[Int(arc4random_uniform(UInt32(json.partsServicesContent.count)))]
                let partServices = partServiceContent.partsServices.filter({ ps.shouldPartServiceBeShown($0)})
                if partServices.count > 0 {
                    let rand = arc4random_uniform(UInt32(partServices.count))
                    let partService = partServices[Int(rand)]
                    if let subpartServices = partService.subPartsServices?.filter({ps.shouldSubPartServiceBeShown($0)}) where subpartServices.count > 0 {
                        let sub_rand = arc4random_uniform(UInt32(subpartServices.count))
                        let subpartService = subpartServices[Int(sub_rand)]
                        let countonBoxes = subpartService.content.contentList.flatMap(({ $0 as? Content.CountOnBoxContent}))
                        if countonBoxes.count > 0 {
                            let countonBox = countonBoxes[Int(arc4random_uniform(UInt32(countonBoxes.count)))]
                            if let number = countonBox.midText, let botText = countonBox.bottomText {
                                self.numberLabel.text = number
                                self.textLabel.text = botText
                                self.partsAndServices = ps
                                self.partService = partService
                                self.subPartService = subpartService
                                self.mainSectiontTile = partServiceContent.title
                                print("countonBoxes found " + String(count))
                                count = Int.max
                                return
                            }
                        } else { print("countonBoxes not found") }
                    }
                }
                else { print("subpartServices not found") }
                count += 1
            }
        }
    }
    
    @IBAction func tapAction(sender: AnyObject) {
        if let ps = self.partService, let pas = self.partsAndServices, let sps = self.subPartService, let title = self.mainSectiontTile {
            self.delegate?.didTapMenuCountOnBox(pas, partService: ps, subPartService: sps, mainSectionTitle: title)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}