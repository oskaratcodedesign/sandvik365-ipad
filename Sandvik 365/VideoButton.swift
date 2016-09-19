//
//  VideoButton.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 15/01/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import Foundation
import NibDesignable

@objc protocol VideoButtonDelegate {
    @objc optional func didTouchEnded()
    @objc optional func favoriteAction(_ video :Video)
}

class VideoButton : NibDesignable {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var delegate: VideoButtonDelegate?
    fileprivate var video: Video!
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.highlightView(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.highlightView(false)
        super.touchesEnded(touches, with: event)
        self.delegate?.didTouchEnded?()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.highlightView(false)
        super.touchesCancelled(touches, with: event)
    }
    
    fileprivate func highlightView(_ highlight: Bool) {
        self.playButton.isHighlighted = highlight
        if highlight {
            self.backgroundColor = Theme.orangePrimaryColor
            self.titleLabel.textColor = UIColor.black
        } else {
            self.backgroundColor = UIColor.clear
            self.titleLabel.textColor = Theme.orangePrimaryColor
        }
    }
    
    func configure(_ video: Video, delegate: VideoButtonDelegate?) {
        self.favoriteButton.isHidden = false
        self.video = video
        self.favoriteButton.isSelected = video.isFavorite
        if let image = video.imageName {
            self.imageView.image = UIImage(named: image)
        }
        self.titleLabel.text = video.title
        self.delegate = delegate
    }
    
    @IBAction func favoriteAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.video.isFavorite = sender.isSelected
        self.delegate?.favoriteAction?(self.video)
    }
    
}
