//
//  CountOnBox.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 02/11/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation
import NibDesignable

class CountOnBox: NibDesignable {

    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    init(frame: CGRect, dic: [NSDictionary], alignRight: Bool) {
        super.init(frame: frame)
        
        for d in dic {
            if let type = d.objectForKey("type") as? String {
                if type.caseInsensitiveCompare("body") == .OrderedSame, let text = d.objectForKey("value") as? String {
                    bodyLabel.text = text
                }
                else if type.caseInsensitiveCompare("content") == .OrderedSame, let countonList  = d.objectForKey("value") as? [NSDictionary] {
                    for counton in countonList {
                        if let value = counton.objectForKey("value") as? NSDictionary {
                            if let config = value.objectForKey("config") as? NSDictionary {
                                if let columns = config.objectForKey("columns") as? [NSDictionary] {
                                    print("columns count", columns.count) //can it be more than one?
                                    if let rows = columns.first?.objectForKey("rows") as? [NSDictionary] {
                                        setTexts(rows)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func setTexts(rows: [NSDictionary]) {
        if rows.count == 3 {
            topLabel.text = rows[0].objectForKey("text") as? String
            middleLabel.text = rows[1].objectForKey("text") as? String
            bottomLabel.text = rows[2].objectForKey("text") as? String
        }
        else if rows.count == 2 {
            //check which should be where
            let firstSize = rows[0].objectForKey("size") as? Int
            let nextSize = rows[1].objectForKey("size") as? Int
            if nextSize >= firstSize {
                topLabel.text = rows[0].objectForKey("text") as? String
                middleLabel.text = rows[1].objectForKey("text") as? String
                bottomLabel.hidden = true
            }
            else {
                middleLabel.text = rows[0].objectForKey("text") as? String
                bottomLabel.text = rows[1].objectForKey("text") as? String
                topLabel.hidden = true
            }
        }
        else if rows.count == 1 {
            middleLabel.text = rows[1].objectForKey("text") as? String
            topLabel.hidden = true
            bottomLabel.hidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}