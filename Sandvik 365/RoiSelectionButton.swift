//
//  RoiSelectionButton.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 14/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit
import NibDesignable

class RoiSelectionButton: NibDesignable {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var line: UIImageView!
    @IBOutlet weak var dot: UIImageView!
    @IBOutlet weak var buttonTopConstraint: NSLayoutConstraint!
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    func isSelected() -> Bool {
        return !button.hidden
    }
    
    func setUnSelected() {
        button.hidden = true
        label.hidden = true
        line.hidden = true
    }
    
    func setSelected(index: Int, text: String) {
        button.hidden = false
        label.hidden = false
        label.text = text
        if index % 2 == 0 {
            buttonTopConstraint.constant = 1000 //minimize
        }
        else {
            line.hidden = false
            buttonTopConstraint.constant = 0
        }
        dot.backgroundColor = UIColor.clearColor()
    }

    private func setUp() {
        button.hidden = true
        label.hidden = true
        line.hidden = true
        setupSelectionDot()
    }
    
    private func setupSelectionDot() {
        dot.layer.cornerRadius = dot.bounds.width/2
        dot.layer.masksToBounds = true
        dot.layer.borderColor = Theme.bluePrimaryColor.CGColor
        dot.layer.borderWidth = 2
    }
    
    
    func unFillDot() {
        dot.backgroundColor = UIColor.clearColor()
    }
    
    
    func fillDot() {
        dot.backgroundColor = Theme.bluePrimaryColor
    }
}
