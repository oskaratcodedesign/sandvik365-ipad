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
    
    @IBOutlet weak var textLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleBelowBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleAboveText: UILabel!
    @IBInspectable var buttonText: String? = nil {
        didSet {
            self.button.setTitle(buttonText, forState: .Normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let frame = button.layer.frame
        button.layer.roundCALayer(frame, fill: false, color: UIColor(red: 0.890, green:0.431, blue:0.153, alpha:1.000))
        button.layer.addSublayer(CALayer().roundCALayer(CGRectMake(2, 2, frame.size.width-4, frame.size.height-4), fill: false, color: UIColor(red: 0.890, green:0.431, blue:0.153, alpha:1.000))!)
    }
    
    func setTexts(string: String) {
        
        titleAboveText.text = string
        titleBelowButtonLabel.text = string
        textLabel.text = string
    }
    
    /*required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let frame = button.layer.frame
        button.layer.roundCALayer(frame, fill: false, color: UIColor(red: 0.890, green:0.431, blue:0.153, alpha:1.000))
        button.layer.addSublayer(CALayer().roundCALayer(CGRectMake(2, 2, frame.size.width-4, frame.size.height-4), fill: false, color: UIColor(red: 0.890, green:0.431, blue:0.153, alpha:1.000))!)
    }*/
    @IBAction func clickAction(sender: UIButton) {
        button.hidden = true
        titleBelowButtonLabel.hidden = true
        textLabel.hidden = false
        titleAboveText.hidden = false
        NSLayoutConstraint.deactivateConstraints([titleBelowBottomConstraint])
        NSLayoutConstraint.activateConstraints([textLabelBottomConstraint])
        self.layoutIfNeeded()
    }
}