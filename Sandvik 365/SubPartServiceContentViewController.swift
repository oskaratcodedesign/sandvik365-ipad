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
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    private let topConstant: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let content = selectedSubPartService.content
        if var title = content.objectForKey("title") as? String {
            if let subtitle = content.objectForKey("subTitle") as? String {
                title += "\n" + subtitle
            }
            titleLabel.text = title
        }
        if let html = content.objectForKey("content") as? NSArray {
            var previousView: UIView = titleLabel
            for part in html {
                if let type = part.objectForKey("type") as? String {
                    if type == "lead", let value = part.objectForKey("value") as? String {
                        previousView = addLead(value, prevView: previousView)
                    }
                    else if type == "body", let value = part.objectForKey("value") as? String {
                        previousView = addBody(value, prevView: previousView)
                    }
                    else if type == "key-feature-list", let value = part.objectForKey("value") as? NSDictionary {
                        previousView = addKeyFeatureList(value, prevView: previousView)
                    }
                    else if type == "columns", let value = part.objectForKey("value") as? NSDictionary {
                        previousView = addColumns(value, prevView: previousView)
                    }
                    else if type == "tabbed-content", let value = part.objectForKey("value") as? NSDictionary {
                        previousView = addTabbedContent(value, prevView: previousView)
                    }
                }
            }
        }
    }
    
    private func addViewAndConstraints(fromView: UIView, toView: UIView, topConstant: CGFloat) {
        
        let topConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: topConstant)
        let trailConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: -leadingConstraint.constant)
        let leadConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: leadingConstraint.constant)
        fromView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(fromView)
        
        NSLayoutConstraint.activateConstraints([topConstraint, trailConstraint, leadConstraint])
    }
    
    
    private func addLead(string: String, prevView: UIView) -> UIView {
        let label = genericLabel(string)
        addViewAndConstraints(label, toView: prevView, topConstant: topConstant)
        
        //todo add picture
        return label
    }
    
    private func addBody(string: String, prevView: UIView) -> UIView {
        let label = genericLabel(string)
        addViewAndConstraints(label, toView: prevView, topConstant: topConstant)
        
        return label
    }
    
    private func addKeyFeatureList(dic: NSDictionary, prevView: UIView) -> UIView {
        let view = UIView()
        
        return view
    }
    
    private func addColumns(dic: NSDictionary, prevView: UIView) -> UIView {
        let view = UIView()
        
        return view
    }
    
    private func addTabbedContent(dic: NSDictionary, prevView: UIView) -> UIView {
        var view = prevView
        if let tabs = dic.objectForKey("config") as? [NSDictionary] {
            for tab in tabs {
                if let title = tab.objectForKey("text") as? String {
                    if let content = tab.objectForKey("content") as? [NSDictionary] {
                        let titleLabel = genericLabel(title)
                        addViewAndConstraints(titleLabel, toView: view, topConstant: topConstant)
                        view = titleLabel
                        for text in content {
                            if let t = text.objectForKey("text") as? String {
                                let textLabel = genericLabel(t)
                                addViewAndConstraints(textLabel, toView: view, topConstant: topConstant)
                                view = textLabel //in case it loops
                            }
                        }
                    }
                }
            }
        }
        //addViewAndConstraints(view, toView: prevView, topConstant: topConstant)
        return view
    }
    
    private func genericLabel(string: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "AktivGroteskCorpMedium-Regular", size: 12.0)
        label.textColor = UIColor.whiteColor()
        
        label.text = string
        return label
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
