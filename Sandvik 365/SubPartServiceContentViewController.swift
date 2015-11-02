//
//  SubPartServiceContentViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 28/10/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import UIKit

class SubPartServiceContentViewController: UIViewController {

    var selectedPartsAndServices: PartsAndServices!
    var selectedSubPartService: SubPartService!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    private let topConstant: CGFloat = 20
    private var alignCountOnBoxRight: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let content = selectedSubPartService.content
        if var title = content.title {
            if let subtitle = content.subtitle {
                title += "\n" + subtitle
            }
            titleLabel.text = title
        }
        var previousView: UIView = titleLabel
        for obj in content.contentList {
            if let value = obj as? SubPartService.Content.Lead {
                previousView = addLead(value, prevView: previousView)
            }
            else if let value = obj as? SubPartService.Content.Body {
                previousView = addBody(value, prevView: previousView)
            }
            else if let value = obj as? SubPartService.Content.KeyFeatureListContent {
                previousView = addKeyFeatureList(value, prevView: previousView)
            }
            else if let value = obj as? SubPartService.Content.CountOnBoxContent {
                previousView = addColumns(value, prevView: previousView)
            }
            else if let value = obj as? SubPartService.Content.TabbedContent {
                previousView = addTabbedContent(value, prevView: previousView)
            }
        }

        let newbottomConstraint = NSLayoutConstraint(item: previousView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        previousView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.deactivateConstraints([bottomConstraint])
        NSLayoutConstraint.activateConstraints([newbottomConstraint])
    }
    
    private func addViewAndConstraints(fromView: UIView, toView: UIView, topConstant: CGFloat) {
        
        let topConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: topConstant)
        let trailConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: -leadingConstraint.constant)
        let leadConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: leadingConstraint.constant)
        fromView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(fromView)
        
        NSLayoutConstraint.activateConstraints([topConstraint, trailConstraint, leadConstraint])
    }
    
    
    private func addLead(content: SubPartService.Content.Lead, prevView: UIView) -> UIView {
        var label = prevView
        
        if let text = content.text {
            label = genericTextLabel(text)
            addViewAndConstraints(label, toView: prevView, topConstant: topConstant)
        }
        
        //todo add picture
        return label
    }
    
    private func addBody(content: SubPartService.Content.Body, prevView: UIView) -> UIView {
        var label = prevView
        
        if let title = content.title {
            label = genericTitleLabel(title)
            addViewAndConstraints(label, toView: prevView, topConstant: topConstant)
        }
        if let text = content.text {
            let prevLabel = label
            label = genericTextLabel(text)
            addViewAndConstraints(label, toView: prevLabel, topConstant: topConstant)
        }
        
        return label
    }
    
    private func addKeyFeatureList(content: SubPartService.Content.KeyFeatureListContent, prevView: UIView) -> UIView {
        let view = KeyFeatureList(frame: CGRectZero, keyFeatureList: content)
        addViewAndConstraints(view, toView: prevView, topConstant: topConstant)
        return view
    }
    
    private func addColumns(content: SubPartService.Content.CountOnBoxContent, prevView: UIView) -> UIView {
        let view = CountOnBox(frame: CGRectZero, countOnBox: content, alignRight: alignCountOnBoxRight)
        addViewAndConstraints(view, toView: prevView, topConstant: topConstant)
        alignCountOnBoxRight = !alignCountOnBoxRight
        return view
    }
    
    private func addTabbedContent(content: SubPartService.Content.TabbedContent, var prevView: UIView) -> UIView {
        var label = prevView
        
        if let tabs = content.tabs {
            for textTitle in tabs {
                if let title = textTitle.title {
                    label = genericTitleLabel(title)
                    addViewAndConstraints(label, toView: prevView, topConstant: topConstant)
                }
                if let text = textTitle.text {
                    let prevLabel = label
                    label = genericTextLabel(text)
                    addViewAndConstraints(label, toView: prevLabel, topConstant: topConstant)
                }
                prevView = label
            }
        }
        return label
    }
    
    private func genericTextLabel(string: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "AktivGroteskCorpMedium-Regular", size: 14.0)
        label.textColor = UIColor.whiteColor()
        
        label.text = string
        return label
    }
    
    private func genericTitleLabel(string: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "AktivGroteskCorpMedium-Regular", size: 16.0)
        label.textColor = UIColor.whiteColor()
        
        label.text = string
        return label
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
