//
//  GradientHorizontalView.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 23/02/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import UIKit

@IBDesignable open class GradientHorizontalView: UIView {
    @IBInspectable open var leftColor: UIColor? {
        didSet {
            configureView()
        }
    }
    @IBInspectable open var rightColor: UIColor? {
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
        let layer = self.layer as! CAGradientLayer
        let locations = [ 0.0, 1.0 ]
        layer.locations = locations as [NSNumber]?
        let color1 = leftColor ?? self.tintColor as UIColor
        let color2 = rightColor ?? UIColor.black as UIColor
        let colors: Array <AnyObject> = [ color1.cgColor, color2.cgColor ]
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.colors = colors
    }
}
