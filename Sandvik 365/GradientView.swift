//
//  GradientView.swift
//  Sandvik 365
//
//  Created by Karl Söderström on 07/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit

@IBDesignable public class GradientView: UIView {
    @IBInspectable public var topColor: UIColor? {
        didSet {
            configureView()
        }
    }
    @IBInspectable public var bottomColor: UIColor? {
        didSet {
            configureView()
        }
    }
    
    override public class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        configureView()
    }
    
    func configureView() {
        let layer = self.layer as! CAGradientLayer
        let locations = [ 0.0, 1.0 ]
        layer.locations = locations
        var color1 = topColor ?? self.tintColor as UIColor
        var color2 = bottomColor ?? UIColor.blackColor() as UIColor
        let colors: Array <AnyObject> = [ color1.CGColor, color2.CGColor ]
        layer.colors = colors
    }
}