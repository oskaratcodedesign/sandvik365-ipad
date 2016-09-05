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
                    let newbottomConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: bodyContainer, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
                    view.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activateConstraints([newbottomConstraint])
                }
            }
            if let keyFeatureList = content.content?.contentList.flatMap({$0 as? Content.KeyFeatureListContent}).first {
                self.keyFeatureTitle.text = keyFeatureList.title
                if let texts = keyFeatureList.texts {
                    for(i, text) in texts.enumerate() {
                        keyFeatureItems[i].title.text = text.title
                        keyFeatureItems[i].text.text = text.text
                    }
                }
            }
        }
    }
    
    private func addBody(content: Content.Body, prevView: UIView?) -> UIView? {
        return addTitlesTextList(content.titleOrTextOrList, prevView: prevView, isLead: false)
    }
    
    private func addTitlesTextList(content: [Content.TitleTextOrList], prevView: UIView?, isLead: Bool) -> UIView? {
        var prevView = prevView
        var top:CGFloat = 0
        for titlesTextList in content {
            switch titlesTextList {
            case .Title(let value):
                let label = genericTitleLabel(value)
                addViewAndConstraints(label, toView: prevView, topConstant: top)
                prevView = label
            case .Text(let value):
                let label = genericTextLabel(value)
                if isLead {
                    top = 0
                }
                else {
                    top = content.filter({
                        switch $0 {
                        case .Title:
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
    
    private func genericTextLabel(string: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "AktivGroteskCorp-Light", size: 16.0)
        label.textColor = UIColor.whiteColor()
        
        label.text = string
        return label
    }
    
    private func genericTitleLabel(string: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "AktivGroteskCorp-Regular", size: 17.0)
        label.textColor = Theme.bluePrimaryColor
        
        label.text = string.uppercaseString
        return label
    }
    
    private func addViewAndConstraints(fromView: UIView, toView: UIView?, topConstant: CGFloat) {
        addViewAndConstraints(fromView, toView: toView, topConstant: topConstant, leftConstant: 0)
    }
    
    private func addViewAndConstraints(fromView: UIView, toView: UIView?, topConstant: CGFloat, leftConstant: CGFloat) {
        addViewAndConstraints(bodyContainer, fromView: fromView, toView: toView, topConstant: topConstant, leftConstant: leftConstant)
    }
    
    private func addViewAndConstraints(superView: UIView, fromView: UIView, toView: UIView?, topConstant: CGFloat, leftConstant: CGFloat) {
        let topConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: toView != nil ? toView : superView, attribute: toView != nil ? NSLayoutAttribute.Bottom : NSLayoutAttribute.Top, multiplier: 1, constant: topConstant)
        let trailConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: superView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        let leadConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: superView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: leftConstant)
        fromView.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(fromView)
        
        NSLayoutConstraint.activateConstraints([topConstraint, trailConstraint, leadConstraint])
    }
}
