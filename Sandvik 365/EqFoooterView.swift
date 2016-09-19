//
//  EqFoooterTableViewCell.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 29/08/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import UIKit

protocol EqFoooterDelegate {
    func didAddSerialNo(_ textField: UITextField) -> Bool
    func getSupport()
}

class EqFoooterView: UIView {

    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var enterView: UIView!
    @IBOutlet weak var errorView: UIView!
    
    @IBOutlet weak var enterText: UITextField!
    @IBOutlet weak var errorText: UITextField!
    var delegate: EqFoooterDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        enterText.attributedPlaceholder = NSAttributedString(string:"Enter here",attributes:[NSForegroundColorAttributeName: Theme.bluePrimaryColor])
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleErrorTap))
        self.errorView.addGestureRecognizer(tap)
        self.enterText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        self.enterText.autocapitalizationType = UITextAutocapitalizationType.allCharacters
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        self.enterText.text = textField.text?.uppercased()
    }
    
    func handleErrorTap() {
        self.errorView.isHidden = true
    }
    
    func configureView(_ showEnterView: Bool){
        self.addView.isHidden = showEnterView
        self.enterView.isHidden = !showEnterView
    }

    @IBAction func closeAction(_ sender: UIButton) {
        self.addView.isHidden = false
        self.enterView.isHidden = true
        self.enterText.resignFirstResponder()
    }
    
    @IBAction func openAction(_ sender: UIButton) {
        self.addView.isHidden = true
        self.enterView.isHidden = false
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        if let del = self.delegate {
            if !del.didAddSerialNo(self.enterText) {
                self.errorText.text = self.enterText.text
                self.errorView.isHidden = false
            } else {
                self.addView.isHidden = false
                self.enterView.isHidden = true
            }
        }
        
        self.enterText.resignFirstResponder()
    }
    
    @IBAction func closeErrorAction(_ sender: UIButton) {
        self.errorView.isHidden = true
    }
    
    @IBAction func getSupportAction(_ sender: UIButton) {
        self.delegate?.getSupport()
    }
}
