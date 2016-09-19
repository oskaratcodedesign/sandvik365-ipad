//
//  RoiNumberView.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 12/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit
import NibDesignable

class RoiInputView: NibDesignable {

    @IBOutlet weak var textView: UITextView!
    
    init(frame: CGRect, selectionInput: SelectionInput) {
        super.init(frame: frame)
        if selectionInput is FireSuppressionInput {
            self.textView.font = UIFont(name: "AktivGroteskCorpMedium-Regular", size: 50)
            
            textView.textContainer.maximumNumberOfLines = 2
        }
        else {
            self.textView.font = UIFont(name: "AktivGroteskCorpMedium-Regular", size: 116)
            
            textView.textContainer.maximumNumberOfLines = 1
        }
        
        textView.textContainer.lineBreakMode = .byTruncatingTail
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadNumber(_ itemIndex: Int, selectionInput: SelectionInput) {
        setText(itemIndex, selectionInput: selectionInput, change: .load)
    }
    
    func increaseNumber(_ itemIndex: Int, selectionInput: SelectionInput) {
        setText(itemIndex, selectionInput: selectionInput, change: .increase)
    }
    
    func decreaseNumber(_ itemIndex: Int, selectionInput: SelectionInput) {
        setText(itemIndex, selectionInput: selectionInput, change: .decrease)
    }
    
    fileprivate func setAttributedString(_ attributedString: NSAttributedString) {
        
        self.textView.attributedText = attributedString
        
        /* ugh bug? need to set thid after setting text */
        textView.textAlignment = .center
        textView.textColor = Theme.bluePrimaryColor
    }
    
    func setAttributedStringWithString(_ string: String) {
        //setting uitextview attributed string or text changes the font, base it on the current attributes */
        let mutString = NSMutableAttributedString(attributedString: textView.attributedText)
        mutString.replaceCharacters(in: NSRange(location: 0, length: textView.attributedText.length), with: string)
        self.textView.attributedText = mutString
    }
    
    fileprivate func setText(_ itemIndex: Int, selectionInput: SelectionInput, change: ChangeInput) {
        let text = selectionInput.changeInput(itemIndex, change: change)
        let font = UIFont(name: "AktivGroteskCorpMedium-Regular", size: self.textView.font!.pointSize)
        if let abr = selectionInput.getInputAbbreviation(itemIndex) {
            setAttributedString(abr.addAbbreviation(text, valueFont: font!, abbreviationFont: UIFont(name: "AktivGroteskCorp-Light", size: self.textView.font!.pointSize)!))
        }
        else {
            setAttributedString(NSAttributedString(string: text, attributes: [NSFontAttributeName:font!]))
        }
    }
}
