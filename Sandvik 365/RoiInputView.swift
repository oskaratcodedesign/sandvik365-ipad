//
//  RoiNumberView.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 12/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit
import NibDesignable

class RoiInputView: NibDesignable, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    func loadNumber(itemIndex: Int, selectionInput: SelectionInput) {
        setText(itemIndex, selectionInput: selectionInput, change: .Load)
    }
    
    func increaseNumber(itemIndex: Int, selectionInput: SelectionInput) {
        setText(itemIndex, selectionInput: selectionInput, change: .Increase)
    }
    
    func decreaseNumber(itemIndex: Int, selectionInput: SelectionInput) {
        setText(itemIndex, selectionInput: selectionInput, change: .Decrease)
    }
    
    private func setText(itemIndex: Int, selectionInput: SelectionInput, change: ChangeInput) {
        let text = selectionInput.changeInput(itemIndex, change: change)
        let font = UIFont(name: "AktivGroteskCorpMedium-Regular", size: self.textField.font!.pointSize)
        if let abr = selectionInput.getInputAbbreviation(itemIndex) {
            self.textField.attributedText = abr.addAbbreviation(text, valueFont: font!, abbreviationFont: UIFont(name: "AktivGroteskCorp-Light", size: self.textField.font!.pointSize)!)
        }
        else {
            self.textField.attributedText = NSAttributedString(string: text, attributes: [NSFontAttributeName:font!])
        }
    }
}
