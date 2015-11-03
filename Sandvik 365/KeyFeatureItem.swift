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
        button.layer.roundCALayer(frame, border: 2, color: UIColor(red: 0.890, green:0.431, blue:0.153, alpha:1.000))
        button.layer.addSublayer(CALayer().roundCALayer(CGRectMake(6, 6, frame.size.width-12, frame.size.height-12), border: 2, color: UIColor(red: 0.890, green:0.431, blue:0.153, alpha:1.000))!)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "tapDidHappen", name: didTapNotificationKey, object: nil)
        //NSLayoutConstraint.deactivateConstraints([textTitleContainerBottomConstraint])
    }
    
    func setTexts(text: SubPartService.Content.TitleAndText) {
        if let title = text.title {
            titleAboveText.text = title.uppercaseString
            titleBelowButtonLabel.text = title.uppercaseString
        }
        if let text = text.text {
            textLabel.text = text
        }
    }
    
    func tapDidHappen() {
        if buttonTitleContainer.hidden {
            buttonTitleContainer.hidden = false
            textTitleContainer.hidden = true
            NSLayoutConstraint.deactivateConstraints([textTitleContainerBottomConstraint])
            NSLayoutConstraint.activateConstraints([buttonTitleContainerBottomConstraint])
        }
    }
    
    @IBAction func clickAction(sender: UIButton) {
        buttonTitleContainer.hidden = true
        textTitleContainer.hidden = false
        NSLayoutConstraint.deactivateConstraints([buttonTitleContainerBottomConstraint])
        NSLayoutConstraint.activateConstraints([textTitleContainerBottomConstraint])
    }
}