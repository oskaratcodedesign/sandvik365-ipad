//
//  VideoButton.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 15/01/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import Foundation
import NibDesignable

protocol VideoButtonDelegate {
    func didTouchEnded()
}

class VideoButton : NibDesignable {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    var delegate: VideoButtonDelegate?
    
    @IBInspectable var videoImage: UIImage? {
        didSet {
            self.imageView.image = videoImage
        }
    }
    
    @IBInspectable var videoTitle: String? {
        didSet {
            self.titleLabel.text = videoTitle
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.highlightView(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.highlightView(false)
        super.touchesEnded(touches, withEvent: event)
        self.delegate?.didTouchEnded()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.highlightView(false)
        super.touchesCancelled(touches, withEvent: event)
    }
    
    private func highlightView(highlight: Bool) {
        self.playButton.highlighted = highlight
        if highlight {
            self.backgroundColor = Theme.orangePrimaryColor
            self.playButton.backgroundColor = Theme.orangePrimaryColor
            self.playButton.setTitleColor(UIColor.clearColor(), forState: .Normal)
            self.titleLabel.textColor = UIColor.blackColor()
        } else {
            self.backgroundColor = UIColor.clearColor()
            self.playButton.backgroundColor = UIColor(white: 0.000, alpha: 0.5)
            self.playButton.setTitleColor(Theme.orangePrimaryColor, forState: .Normal)
            self.titleLabel.textColor = Theme.orangePrimaryColor
        }
    }
    
}