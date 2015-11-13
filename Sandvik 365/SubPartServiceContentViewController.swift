//
//  SubPartServiceContentViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 28/10/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import UIKit

let didTapNotificationKey = "didTapNotificationKey"

class SubPartServiceContentViewController: UIViewController, UIScrollViewDelegate {

    var selectedPartsAndServices: PartsAndServices!
    var selectedContent: Content!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    @IBOutlet var paddingView: UIView!
    @IBOutlet var subContentView: UIView!
    @IBOutlet var stripeImageView: UIImageView!
    private let topConstant: CGFloat = 20
    private var alignCountOnBoxRight: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = UIImage(named: "sandvik_stripes_bg_mask") {
            let mask = CALayer()
            mask.frame = CGRectMake(0, 0, image.size.width, image.size.height)
            mask.contents = image.CGImage
            
            //stripeImageView.layer.masksToBounds = true
            stripeImageView.layer.mask = mask
        }
        
        if let view = self.view as? ViewWithBGImage {
            view.setImageBG(self.selectedPartsAndServices.businessType.backgroundImageName)
        }
        let content = selectedContent
        if var title = content.title {
            if let subtitle = content.subtitle {
                title += "\n" + subtitle
            }
            titleLabel.text = title.uppercaseString
        }
        var previousView: UIView = paddingView
        for obj in content.contentList {
            if let value = obj as? Content.Lead {
                previousView = addLead(value, images: content.images, prevView: previousView)
            }
            else if let value = obj as? Content.Body {
                previousView = addBody(value, prevView: previousView)
            }
            else if let value = obj as? Content.KeyFeatureListContent {
                previousView = addKeyFeatureList(value, prevView: previousView)
            }
            else if let value = obj as? Content.CountOnBoxContent {
                previousView = addColumns(value, prevView: previousView)
            }
            else if let value = obj as? Content.TabbedContent {
                previousView = addTabbedContent(value, prevView: previousView)
            }
        }
        previousView = addStripesImage(previousView)
        let newbottomConstraint = NSLayoutConstraint(item: previousView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: subContentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -50)
        previousView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.deactivateConstraints([bottomConstraint])
        NSLayoutConstraint.activateConstraints([newbottomConstraint])
    }
    
    private func addStripesImage(prevView: UIView) -> UIView {
        let view = UIImageView(image: UIImage(named: "sandvik_stripes_bg"))
        view.contentMode = UIViewContentMode.ScaleAspectFill
        addViewAndConstraints(contentView, fromView: view, toView: prevView, topConstant: topConstant, leftConstant: 0)
        return view
    }
    
    @IBAction func handleTap(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(didTapNotificationKey, object: self)
        
        if self.scrollView.contentOffset.y < self.scrollView.bounds.size.height {
            self.scrollView.scrollRectToVisible(CGRect(origin: CGPoint(x: 0, y: self.scrollView.bounds.size.height), size: scrollView.bounds.size), animated: true)
        }
    }
    
    private func addViewAndConstraints(fromView: UIView, toView: UIView, topConstant: CGFloat) {
        addViewAndConstraints(fromView, toView: toView, topConstant: topConstant, leftConstant: 0)
    }
    
    private func addViewAndConstraints(fromView: UIView, toView: UIView, topConstant: CGFloat, leftConstant: CGFloat) {
        addViewAndConstraints(subContentView, fromView: fromView, toView: toView, topConstant: topConstant, leftConstant: leftConstant)
    }
    
    private func addViewAndConstraints(superView: UIView, fromView: UIView, toView: UIView, topConstant: CGFloat, leftConstant: CGFloat) {
        
        let topConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: topConstant)
        let trailConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: superView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        let leadConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: superView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: leftConstant)
        fromView.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(fromView)
        
        NSLayoutConstraint.activateConstraints([topConstraint, trailConstraint, leadConstraint])
    }
    
    
    private func addLead(content: Content.Lead, images: [NSURL], prevView: UIView) -> UIView {
        var label = prevView
        
        if let text = content.text {
            label = leadLabel(text)
            addViewAndConstraints(label, toView: prevView, topConstant: topConstant)
        }
        for url in images {
            if let image = ImageCache.getImage(url) {
                var imgWidth:CGFloat = image.size.width
                var imgHeight:CGFloat = image.size.height
                let maxHeight:CGFloat = 200
                if imgHeight > maxHeight {
                    imgWidth = (maxHeight/image.size.height) * image.size.width
                    imgHeight = maxHeight
                }
                let imageView = UIImageView(image: image)
                imageView.contentMode = UIViewContentMode.ScaleAspectFit
                let widthConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: imgWidth)
                let heightConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: imgHeight)
                let centerX = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: label, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
                let topConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: label, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 36)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                subContentView.addSubview(imageView)
                NSLayoutConstraint.activateConstraints([widthConstraint, centerX, heightConstraint, topConstraint])
                label = imageView
            }
        }
        
        return label
    }
    
    private func addBody(content: Content.Body, var prevView: UIView) -> UIView {
        var label = prevView
        var top:CGFloat = 45
        for titlesAndText in content.titlesAndText {
            if let title = titlesAndText.title {
                label = genericTitleLabel(title)
                addViewAndConstraints(label, toView: prevView, topConstant: top)
            }
            if let text = titlesAndText.text {
                let prevLabel = label
                label = genericTextLabel(text)
                addViewAndConstraints(label, toView: prevLabel, topConstant: 0)
                prevView = label
            }
            top = topConstant
        }
        
        return label
    }
    
    private func addKeyFeatureList(content: Content.KeyFeatureListContent, var prevView: UIView) -> UIView {
        var top:CGFloat = 45
        if let title = content.title {
            let label = genericTitleLabel(title)
            addViewAndConstraints(label, toView: prevView, topConstant: top)
            prevView = label
            top = topConstant
        }
        let view = KeyFeatureList(frame: CGRectZero, keyFeatureList: content)
        addViewAndConstraints(view, toView: prevView, topConstant: top)
        return view
    }
    
    private func addColumns(content: Content.CountOnBoxContent, prevView: UIView) -> UIView {
        let view = CountOnBox(frame: CGRectZero, countOnBox: content, alignRight: alignCountOnBoxRight)
        addViewAndConstraints(view, toView: prevView, topConstant: 45)
        alignCountOnBoxRight = !alignCountOnBoxRight
        return view
    }
    
    private func addTabbedContent(content: Content.TabbedContent, var prevView: UIView) -> UIView {
        var label = prevView
        
        if let tabs = content.tabs {
            var top:CGFloat = 45
            for textTitle in tabs {
                if let title = textTitle.title {
                    label = genericTitleLabel(title)
                    addViewAndConstraints(label, toView: prevView, topConstant: top)
                }
                if let text = textTitle.text {
                    let prevLabel = label
                    label = genericTextLabel(text)
                    addViewAndConstraints(label, toView: prevLabel, topConstant: 0)
                }
                prevView = label
                top = topConstant
            }
        }
        return label
    }
    
    private func leadLabel(string: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "AktivGroteskCorpMedium-Regular", size: 15.0)
        label.textColor = UIColor.whiteColor()
        //label.textAlignment = .Center
        label.text = string
        return label
    }
    
    private func genericTextLabel(string: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "AktivGroteskCorp-Light", size: 15.0)
        label.textColor = UIColor.whiteColor()
        
        label.text = string
        return label
    }
    
    private func genericTitleLabel(string: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "AktivGroteskCorp-Regular", size: 16.0)
        label.textColor = UIColor(red: 0.082, green: 0.678, blue: 0.929, alpha: 1.000)
        
        label.text = string.uppercaseString
        return label
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            return
        }
        
        let height = scrollView.bounds.height
        //var target = targetContentOffset.memory
        var target = scrollView.contentOffset
        
        if target.y < height / 2 {
            target.y = 0
        } else if target.y < height {
            target.y = height
        }
        
        scrollView.scrollRectToVisible(CGRect(origin: target, size: scrollView.bounds.size), animated: true)
    }
    
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity == CGPointZero {
            return
        }
        
        let height = scrollView.bounds.height
        var target = targetContentOffset.memory
        
        if target.y < height / 2 {
            target.y = 0
        } else if target.y < height {
            target.y = height
        }
        
        targetContentOffset.memory = target
    }

}
