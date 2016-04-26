//
//  SubPartServiceContentViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 28/10/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import UIKit

let didTapNotificationKey = "didTapNotificationKey"

class SubPartServiceContentViewController: UIViewController, UIScrollViewDelegate, ContactUsViewDelegate, RegionSelectorDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIDocumentInteractionControllerDelegate {

    var selectedPartsAndServices: PartsAndServices!
    var selectedContent: Content!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var contactUsView: ContactUsView!
    @IBOutlet var paddingView: UIView!
    @IBOutlet var subContentView: UIView!
    @IBOutlet var stripeImageView: UIImageView!
    @IBOutlet weak var filesCollectionView: UICollectionView!
    @IBOutlet weak var filesCollectionViewHeight: NSLayoutConstraint!
    private let topConstant: CGFloat = 20
    private var changedTopConstant: CGFloat = 0
    
    private var alignCountOnBoxRight: Bool = true
    private var regionSelector: RegionSelector?
    
    @IBOutlet weak var documentsLabel: UILabel!
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
                previousView = addLead(value, images: content.images, previousView: previousView)
            }
            else if let value = obj as? Content.Body {
                previousView = addBody(value, previousView: previousView)
            }
            else if let value = obj as? Content.KeyFeatureListContent {
                previousView = addKeyFeatureList(value, previousView: previousView)
            }
            else if let value = obj as? Content.CountOnBoxContent {
                previousView = addColumns(value, prevView: previousView)
            }
            else if let value = obj as? Content.TabbedContent {
                previousView = addTabbedContent(value, previousView: previousView)
            }
        }
        //previousView = addStripesImage(previousView)
        let newbottomConstraint = NSLayoutConstraint(item: previousView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: subContentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        previousView.translatesAutoresizingMaskIntoConstraints = false
        //NSLayoutConstraint.deactivateConstraints([bottomConstraint])
        NSLayoutConstraint.activateConstraints([newbottomConstraint])
        self.contactUsView.delegate = self
        self.filesCollectionView.hidden = true
        self.documentsLabel.hidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.selectedContent.pdfs.count > 0 {
            let contentsize = self.filesCollectionView.contentSize
            if contentsize.height != self.filesCollectionView.bounds.size.height {
                self.view.setNeedsUpdateConstraints()
            }
        }
    }
    
    override func updateViewConstraints() {
        if self.selectedContent.pdfs.count > 0 {
            self.filesCollectionView.hidden = false
            self.documentsLabel.hidden = false;
            let contentsize = self.filesCollectionView.contentSize
            if contentsize.height > 0 {
                filesCollectionViewHeight.constant = contentsize.height
            }
        }
        else {
            filesCollectionViewHeight.constant = 0
        }
        super.updateViewConstraints()
    }
    
    private func addStripesImage(prevView: UIView) -> UIView {
        let view = UIImageView(image: UIImage(named: "sandvik_stripes_bg"))
        view.contentMode = UIViewContentMode.ScaleAspectFill
        addViewAndConstraints(contentView, fromView: view, toView: prevView, topConstant: 50, leftConstant: 0)
        return view
    }
    
    @IBAction func handleTap(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(didTapNotificationKey, object: self)
        
        if self.scrollView.contentOffset.y < self.scrollView.bounds.size.height {
            self.scrollView.scrollRectToVisible(CGRect(origin: CGPoint(x: 0, y: self.scrollView.bounds.size.height), size: scrollView.bounds.size), animated: true)
        }
    }
    
    func didSelectRegion() {
        if let regionSelector = self.regionSelector {
            regionSelector.removeFromSuperview()
            self.regionSelector = nil
        }
        self.contactUsView.didSelectRegion()
    }
    
    func showRegionAction(allRegions: [RegionData]) {
        regionSelector = RegionSelector(del: self, allRegions: allRegions)
        let constraints = regionSelector!.fillConstraints(self.view, topBottomConstant: 0, leadConstant: 0, trailConstant: 0)
        regionSelector!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(regionSelector!)
        NSLayoutConstraint.activateConstraints(constraints)
    }
    
    private func addViewAndConstraints(fromView: UIView, toView: UIView, topConstant: CGFloat) {
        addViewAndConstraints(fromView, toView: toView, topConstant: topConstant, leftConstant: 0)
    }
    
    private func addViewAndConstraints(fromView: UIView, toView: UIView, topConstant: CGFloat, leftConstant: CGFloat) {
        addViewAndConstraints(subContentView, fromView: fromView, toView: toView, topConstant: topConstant, leftConstant: leftConstant)
    }
    
    private func addViewAndConstraints(superView: UIView, fromView: UIView, toView: UIView, topConstant: CGFloat, leftConstant: CGFloat) {
        var top = topConstant
        if(changedTopConstant > 0) {
            top = changedTopConstant
            changedTopConstant = 0
        }
        let topConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: toView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: top)
        let trailConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: superView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        let leadConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: superView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: leftConstant)
        fromView.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(fromView)
        
        NSLayoutConstraint.activateConstraints([topConstraint, trailConstraint, leadConstraint])
    }
    
    
    private func addLead(content: Content.Lead, images: [NSURL], previousView: UIView) -> UIView {
        var prevView = addTitlesTextList(content.titleOrTextOrList, previousView: previousView, isLead: true)
        
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
                let centerX = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: prevView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
                let topConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: prevView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 50)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                subContentView.addSubview(imageView)
                NSLayoutConstraint.activateConstraints([widthConstraint, centerX, heightConstraint, topConstraint])
                prevView = imageView
                changedTopConstant = 50
            }
        }
        
        return prevView
    }
    
    private func addBody(content: Content.Body, previousView: UIView) -> UIView {
        return addTitlesTextList(content.titleOrTextOrList, previousView: previousView, isLead: false)
    }
    
    private func addTitlesTextList(content: [Content.TitleTextOrList], previousView: UIView, isLead: Bool) -> UIView {
        var prevView = previousView
        var top:CGFloat = 45
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
            case .List(let value):
                for titleText in value {
                    let view = listLabels(titleText)
                    addViewAndConstraints(view, toView: prevView, topConstant: topConstant)
                    prevView = view
                }
            }
            top = topConstant
        }
        
        return prevView
    }
    
    private func addKeyFeatureList(content: Content.KeyFeatureListContent, previousView: UIView) -> UIView {
        var top:CGFloat = 45
        var prevView = previousView
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
    
    private func addTabbedContent(content: Content.TabbedContent, previousView: UIView) -> UIView {
        var label = previousView
        var prevView = previousView
        
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
        label.font = UIFont(name: "AktivGroteskCorpMedium-Regular", size: 16.0)
        label.textColor = UIColor.whiteColor()
        //label.textAlignment = .Center
        label.text = string
        return label
    }
    
    private func listLabels(titleAndText: Content.TitleAndText) -> UIView {
        let listlabel = genericTextLabel("-")
        let container = UIView()
        var topConstraint = NSLayoutConstraint(item: listlabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        var leadConstraint = NSLayoutConstraint(item: listlabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        listlabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(listlabel)
        
        NSLayoutConstraint.activateConstraints([topConstraint, leadConstraint])
        let mutString = NSMutableAttributedString()
        if titleAndText.title != nil {
            mutString.appendAttributedString(NSAttributedString(string: titleAndText.title!+"\n", attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorp-Light", size: 16.0)!]))
        }
        if titleAndText.text != nil {
            mutString.appendAttributedString(NSAttributedString(string: titleAndText.text!, attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorp-Light", size: 16.0)!]))
        }
        
        let textlabel = genericTextLabel("")
        textlabel.attributedText = mutString
        topConstraint = NSLayoutConstraint(item: textlabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        leadConstraint = NSLayoutConstraint(item: textlabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: listlabel, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 10)
        let trailConstraint = NSLayoutConstraint(item: textlabel, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        let botConstraint = NSLayoutConstraint(item: textlabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: container, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        textlabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(textlabel)
        
        NSLayoutConstraint.activateConstraints([topConstraint, leadConstraint, botConstraint, trailConstraint])
        
        return container
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
        label.textColor = UIColor(red: 0.082, green: 0.678, blue: 0.929, alpha: 1.000)
        
        label.text = string.uppercaseString
        return label
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
    
    //file collectionview
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedContent.pdfs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ToolsCollectionViewCell
        let pdf = selectedContent.pdfs[indexPath.row]
        cell.button.setTitle(pdf.title, forState: .Normal)
        return cell
    }
    
    @IBAction func documentAction(sender: UIButton) {
        let r = self.filesCollectionView.convertRect(sender.bounds, fromView: sender)
        if let indexPath = self.filesCollectionView.indexPathForItemAtPoint(r.origin) {
            let pdf = selectedContent.pdfs[indexPath.row]
            if let url = FileCache.getStoredFileURL(pdf.url) {
                let vc = UIDocumentInteractionController(URL: url)
                vc.delegate = self
                vc.presentPreviewAnimated(true)
            }
        }
    }
    
    func documentInteractionControllerViewForPreview(controller: UIDocumentInteractionController) -> UIView? {
        return nil
    }
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerDidEndPreview(controller: UIDocumentInteractionController) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.showLogoView()
    }
    
    func documentInteractionControllerWillBeginPreview(controller: UIDocumentInteractionController) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.hideLogoView()
    }

}
