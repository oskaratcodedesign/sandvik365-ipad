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
    
    init(frame: CGRect, countOnBox: SubPartService.Content.CountOnBoxContent, alignRight: Bool) {
        super.init(frame: frame)
        //TODO handle align left ?
        if let title = countOnBox.title {
                bodyLabel.text = title
        }
        topLabel.hidden = true
        middleLabel.hidden = true
        bottomLabel.hidden = true
        
        if let toptext = countOnBox.topText {
            topLabel.text = toptext
            topLabel.hidden = false
        }
        if let midtext = countOnBox.midText {
            middleLabel.text = midtext
            middleLabel.hidden = false
        }
        if let bottomtext = countOnBox.bottomText {
            bottomLabel.text = bottomtext
            bottomLabel.hidden = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}