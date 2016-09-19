//
//  FireSupressionResultViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 01/02/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import UIKit

class FireSuppressionResultViewController: UIViewController {

    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var partLabel: UILabel!
    
    @IBOutlet weak var bodyContainer: UIView!
    
    @IBOutlet weak var keyFeatureTitle: UILabel!
    @IBOutlet var keyFeatureItems: [FireSuppressionKeyFeatureItem]!
    
    var selectedInput: FireSuppressionInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let content = self.selectedInput.selectedTemperature == .Above ? self.selectedInput.selectedModel.aboveZero : self.selectedInput.selectedModel.belowZero {
            self.sizeLabel.text = content.sizes?.first
            if let q = content.quantity {
                self.quantityLabel.text = String(q)
            }
            self.partLabel.text = content.partNumbers?.first
            
            if let body = content.content?.contentList.flatMap({$0 as? Content.Body}).first {
                if let view = addBody(body, prevView: nil) {
                    let newbottomConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: bodyContainer, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
                    view.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([newbottomConstraint])
                }
            }
            if let keyFeatureList = content.content?.contentList.flatMap({$0 as? Content.KeyFeatureListContent}).first {
                self.keyFeatureTitle.text = keyFeatureList.title
                if let texts = keyFeatureList.texts {
                    for(i, text) in texts.enumerated() {
                        keyFeatureItems[i].title.text = text.title
                        keyFeatureItems[i].text.text = text.text
                    }
                }
            }
        }
    }
    
    fileprivate func addBody(_ content: Content.Body, prevView: UIView?) -> UIView? {
        return addTitlesTextList(content.titleOrTextOrList, prevView: prevView, isLead: false)
    }
    
    fileprivate func addTitlesTextList(_ content: [Content.TitleTextOrList], prevView: UIView?, isLead: Bool) -> UIView? {
        var prevView = prevView
        var top:CGFloat = 0
        for titlesTextList in content {
            switch titlesTextList {
            case .title(let value):
                let label = genericTitleLabel(value)
                addViewAndConstraints(label, toView: prevView, topConstant: top)
                prevView = label
            case .text(let value):
                let label = genericTextLabel(value)
                if isLead {
                    top = 0
                }
                else {
                    top = content.filter({
                        switch $0 {
                        case .title:
                            return true
                        default:
                            return false
                        }}).count > 0 ? 0 : top
                }
                addViewAndConstraints(label, toView: prevView, topConstant: top)
                prevView = label
            /*case .List(let value):
                for titleText in value {
                    let view = listLabels(titleText)
                    addViewAndConstraints(view, toView: prevView, topConstant: topConstant)
                    prevView = view
                }*/
            default:
                break
            }
            top = 20
        }
        
        return prevView
    }
    
    fileprivate func genericTextLabel(_ string: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "AktivGroteskCorp-Light", size: 16.0)
        label.textColor = UIColor.white
        
        label.text = string
        return label
    }
    
    fileprivate func genericTitleLabel(_ string: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "AktivGroteskCorp-Regular", size: 17.0)
        label.textColor = Theme.bluePrimaryColor
        
        label.text = string.uppercased()
        return label
    }
    
    fileprivate func addViewAndConstraints(_ fromView: UIView, toView: UIView?, topConstant: CGFloat) {
        addViewAndConstraints(fromView, toView: toView, topConstant: topConstant, leftConstant: 0)
    }
    
    fileprivate func addViewAndConstraints(_ fromView: UIView, toView: UIView?, topConstant: CGFloat, leftConstant: CGFloat) {
        addViewAndConstraints(bodyContainer, fromView: fromView, toView: toView, topConstant: topConstant, leftConstant: leftConstant)
    }
    
    fileprivate func addViewAndConstraints(_ superView: UIView, fromView: UIView, toView: UIView?, topConstant: CGFloat, leftConstant: CGFloat) {
        let topConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: toView != nil ? toView : superView, attribute: toView != nil ? NSLayoutAttribute.bottom : NSLayoutAttribute.top, multiplier: 1, constant: topConstant)
        let trailConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: superView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        let leadConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: superView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: leftConstant)
        fromView.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(fromView)
        
        NSLayoutConstraint.activate([topConstraint, trailConstraint, leadConstraint])
    }
}
