//
//  GradientView.swift
//  Sandvik 365
//
//  Created by Karl Söderström on 07/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit

@IBDesignable open class GradientView: UIView {
    @IBInspectable open var topColor: UIColor? {
        didSet {
            configureView()
        }
    }
    @IBInspectable open var bottomColor: UIColor? {
        didSet {
            configureView()
        }
    }
    
    @IBInspectable open var fillColor: UIColor? {
        didSet {
            configureView()
        }
    }
    
    override open class var layerClass : AnyClass {
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
    
    open override func tintColorDidChange() {
        super.tintColorDidChange()
        configureView()
    }
    
    func configureView() {
        if let fillColor = self.fillColor {
            self.backgroundColor = fillColor
        }
        else{
            let layer = self.layer as! CAGradientLayer
            let locations = [ 0.0, 1.0 ]
            layer.locations = locations as [NSNumber]?
            let color1 = topColor ?? self.tintColor as UIColor
            let color2 = bottomColor ?? UIColor.black as UIColor
            let colors: Array <AnyObject> = [ color1.cgColor, color2.cgColor ]
            layer.colors = colors
        }
    }
}
