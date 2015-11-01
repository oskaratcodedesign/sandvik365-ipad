//
//  KeyFeatureList.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 30/10/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation
import NibDesignable

class KeyFeatureItem: NibDesignable {


    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var titleBelowButtonLabel: UILabel!
    
    @IBOutlet weak var buttonTitleContainer: UIView!
    @IBOutlet weak var textTitleContainer: UIView!
    @IBOutlet weak var textTitleContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonTitleContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleAboveText: UILabel!
    
    @IBInspectable var buttonText: String? = nil {
        didSet {
            self.button.setTitle(buttonText, forState: .Normal)
        }
    }
    
    override init(frame: CGRect) {//need for showing in ib, otherwise crash when layouting nib
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let frame = button.layer.frame
        button.layer.roundCALayer(frame, fill: false, color: UIColor(red: 0.890, green:0.431, blue:0.153, alpha:1.000))
        button.layer.addSublayer(CALayer().roundCALayer(CGRectMake(2, 2, frame.size.width-4, frame.size.height-4), fill: false, color: UIColor(red: 0.890, green:0.431, blue:0.153, alpha:1.000))!)
        //NSLayoutConstraint.deactivateConstraints([textTitleContainerBottomConstraint])
    }
    
    func setTexts(string: String) {
        if let title = string.stringBetweenStrongTag() {
            var text = string.stringByReplacingOccurrencesOfString(title, withString: "")
            text = text.stripHTML()
            
            titleAboveText.text = title
            titleBelowButtonLabel.text = title
            textLabel.text = text
        }
        
    }
    
    @IBAction func clickAction(sender: UIButton) {
        buttonTitleContainer.hidden = true
        textTitleContainer.hidden = false
        NSLayoutConstraint.deactivateConstraints([buttonTitleContainerBottomConstraint])
        NSLayoutConstraint.activateConstraints([textTitleContainerBottomConstraint])
    }
}