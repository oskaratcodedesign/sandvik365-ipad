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
            self.button.setTitle(buttonText, for: UIControlState())
        }
    }
    
    override init(frame: CGRect) {//need for showing in ib, otherwise crash when layouting nib
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let frame = button.layer.frame
        button.layer.roundCALayer(frame, border: 2, color: Theme.orangePrimaryColor)
        button.layer.addSublayer(CALayer().roundCALayer(CGRect(x: 6, y: 6, width: frame.size.width-12, height: frame.size.height-12), border: 2, color: Theme.orangePrimaryColor)!)
        NSLayoutConstraint.deactivate([textTitleContainerBottomConstraint])
    }
    
    func setTexts(_ text: Content.TitleAndText) {
        if let title = text.title {
            titleAboveText.text = title.uppercased()
            titleBelowButtonLabel.text = title.uppercased()
        }
        if let text = text.text {
            textLabel.text = text
        }
        
        NotificationCenter.default.addObserver(self, selector:#selector(tapDidHappen), name: NSNotification.Name(rawValue: didTapNotificationKey), object: nil)
    }
    
    func tapDidHappen() {
        if buttonTitleContainer != nil && buttonTitleContainer.isHidden {
            buttonTitleContainer.isHidden = false
            textTitleContainer.isHidden = true
            NSLayoutConstraint.deactivate([textTitleContainerBottomConstraint])
        }
    }
    
    @IBAction func clickAction(_ sender: UIButton) {
        buttonTitleContainer.isHidden = true
        textTitleContainer.isHidden = false
        NSLayoutConstraint.activate([textTitleContainerBottomConstraint])
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
