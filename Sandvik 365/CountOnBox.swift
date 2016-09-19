//
//  CountOnBox.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 02/11/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import Foundation
import NibDesignable

class CountOnBox: NibDesignable {

    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var labelContanier: UIView!
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    init(frame: CGRect, countOnBox: Content.CountOnBoxContent, alignRight: Bool) {
        super.init(frame: frame)
        //TODO handle align left ?
        if let title = countOnBox.title {
                bodyLabel.text = title
        }
        var prevView: UIView? = nil
        for countOnBox in countOnBox.texts {
            let view: UIView
            if countOnBox.isLargest {
                let v = CountOnBoxBigLabel()
                v.label.text = countOnBox.text
                view = v
            }
            else{
                let v = CountOnBoxSmallLabel()
                v.label.text = countOnBox.text
                view = v
            }
    
            addViewAndConstraints(labelContanier, fromView: view, toView: prevView, topConstant: 0, leftConstant: 100)
            prevView = view
        }
        if let prevView = prevView {
            let newbottomConstraint = NSLayoutConstraint(item: prevView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: bottomLine, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 3)
            prevView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.deactivate([topConstraint])
            NSLayoutConstraint.activate([newbottomConstraint])
        }
        
    }
    
    fileprivate func addViewAndConstraints(_ superView: UIView, fromView: UIView, toView: UIView?, topConstant: CGFloat, leftConstant: CGFloat) {
        let topConstraint: NSLayoutConstraint
        if toView == nil {
            topConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: superView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: topConstant)
        }
        else{
            topConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: toView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: topConstant)
        }
        let trailConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: superView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        let leadConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: superView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: leftConstant)
        fromView.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(fromView)
        
        NSLayoutConstraint.activate([topConstraint, trailConstraint, leadConstraint])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
