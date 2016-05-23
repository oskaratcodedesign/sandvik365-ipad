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
    @IBOutlet var textTitleContainerBottomConstraint: NSLayoutConstraint!
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
        button.layer.roundCALayer(frame, border: 2, color: Theme.orangePrimaryColor)
        button.layer.addSublayer(CALayer().roundCALayer(CGRectMake(6, 6, frame.size.width-12, frame.size.height-12), border: 2, color: Theme.orangePrimaryColor)!)
        NSLayoutConstraint.deactivateConstraints([textTitleContainerBottomConstraint])
    }
    
    func setTexts(text: Content.TitleAndText) {
        if let title = text.title {
            titleAboveText.text = title.uppercaseString
            titleBelowButtonLabel.text = title.uppercaseString
        }
        if let text = text.text {
            textLabel.text = text
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(tapDidHappen), name: didTapNotificationKey, object: nil)
    }
    
    func tapDidHappen() {
        if buttonTitleContainer != nil && buttonTitleContainer.hidden {
            buttonTitleContainer.hidden = false
            textTitleContainer.hidden = true
            NSLayoutConstraint.deactivateConstraints([textTitleContainerBottomConstraint])
        }
    }
    
    @IBAction func clickAction(sender: UIButton) {
        buttonTitleContainer.hidden = true
        textTitleContainer.hidden = false
        NSLayoutConstraint.activateConstraints([textTitleContainerBottomConstraint])
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}