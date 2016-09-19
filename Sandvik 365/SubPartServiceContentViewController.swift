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
    fileprivate let topConstant: CGFloat = 20
    fileprivate var changedTopConstant: CGFloat = 0
    
    fileprivate var alignCountOnBoxRight: Bool = true
    fileprivate var regionSelector: RegionSelector?
    
    @IBOutlet weak var documentsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = UIImage(named: "sandvik_stripes_bg_mask") {
            let mask = CALayer()
            mask.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            mask.contents = image.cgImage
            
            //stripeImageView.layer.masksToBounds = true
            stripeImageView.layer.mask = mask
        }
        
        if let view = self.view as? ViewWithBGImage {
            view.setImageBG(self.selectedPartsAndServices.businessType.backgroundImageName)
        }
        let content = selectedContent
        if var title = content?.title {
            if let subtitle = content?.subtitle {
                title += "\n" + subtitle
            }
            titleLabel.text = title.uppercased()
        }
        var previousView: UIView = paddingView
        for obj in (content?.contentList)! {
            if let value = obj as? Content.Lead {
                previousView = addLead(value, images: content?.images as! [URL], previousView: previousView)
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
        let newbottomConstraint = NSLayoutConstraint(item: previousView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: subContentView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        previousView.translatesAutoresizingMaskIntoConstraints = false
        //NSLayoutConstraint.deactivateConstraints([bottomConstraint])
        NSLayoutConstraint.activate([newbottomConstraint])
        self.contactUsView.delegate = self
        self.filesCollectionView.isHidden = true
        self.documentsLabel.isHidden = true
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
            self.filesCollectionView.isHidden = false
            self.documentsLabel.isHidden = false;
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
    
    fileprivate func addStripesImage(_ prevView: UIView) -> UIView {
        let view = UIImageView(image: UIImage(named: "sandvik_stripes_bg"))
        view.contentMode = UIViewContentMode.scaleAspectFill
        addViewAndConstraints(contentView, fromView: view, toView: prevView, topConstant: 50, leftConstant: 0)
        return view
    }
    
    @IBAction func handleTap(_ sender: AnyObject) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: didTapNotificationKey), object: self)
        
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
    
    func showRegionAction(_ allRegions: [RegionData]) {
        regionSelector = RegionSelector(del: self, allRegions: allRegions)
        let constraints = regionSelector!.fillConstraints(self.view, topBottomConstant: 0, leadConstant: 0, trailConstant: 0)
        regionSelector!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(regionSelector!)
        NSLayoutConstraint.activate(constraints)
    }
    
    fileprivate func addViewAndConstraints(_ fromView: UIView, toView: UIView, topConstant: CGFloat) {
        addViewAndConstraints(fromView, toView: toView, topConstant: topConstant, leftConstant: 0)
    }
    
    fileprivate func addViewAndConstraints(_ fromView: UIView, toView: UIView, topConstant: CGFloat, leftConstant: CGFloat) {
        addViewAndConstraints(subContentView, fromView: fromView, toView: toView, topConstant: topConstant, leftConstant: leftConstant)
    }
    
    fileprivate func addViewAndConstraints(_ superView: UIView, fromView: UIView, toView: UIView, topConstant: CGFloat, leftConstant: CGFloat) {
        var top = topConstant
        if(changedTopConstant > 0) {
            top = changedTopConstant
            changedTopConstant = 0
        }
        let topConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: toView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: top)
        let trailConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: superView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        let leadConstraint = NSLayoutConstraint(item: fromView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: superView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: leftConstant)
        fromView.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(fromView)
        
        NSLayoutConstraint.activate([topConstraint, trailConstraint, leadConstraint])
    }
    
    
    fileprivate func addLead(_ content: Content.Lead, images: [URL], previousView: UIView) -> UIView {
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
                imageView.contentMode = UIViewContentMode.scaleAspectFit
                let widthConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: imgWidth)
                let heightConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: imgHeight)
                let centerX = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: prevView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
                let topConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: prevView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 50)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                subContentView.addSubview(imageView)
                NSLayoutConstraint.activate([widthConstraint, centerX, heightConstraint, topConstraint])
                prevView = imageView
                changedTopConstant = 50
            }
        }
        
        return prevView
    }
    
    fileprivate func addBody(_ content: Content.Body, previousView: UIView) -> UIView {
        return addTitlesTextList(content.titleOrTextOrList, previousView: previousView, isLead: false)
    }
    
    fileprivate func addTitlesTextList(_ content: [Content.TitleTextOrList], previousView: UIView, isLead: Bool) -> UIView {
        var prevView = previousView
        var top:CGFloat = 45
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
            case .list(let value):
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
    
    fileprivate func addKeyFeatureList(_ content: Content.KeyFeatureListContent, previousView: UIView) -> UIView {
        var top:CGFloat = 45
        var prevView = previousView
        if let title = content.title {
            let label = genericTitleLabel(title)
            addViewAndConstraints(label, toView: prevView, topConstant: top)
            prevView = label
            top = topConstant
        }
        let view = KeyFeatureList(frame: CGRect.zero, keyFeatureList: content)
        addViewAndConstraints(view, toView: prevView, topConstant: top)
        return view
    }
    
    fileprivate func addColumns(_ content: Content.CountOnBoxContent, prevView: UIView) -> UIView {
        let view = CountOnBox(frame: CGRect.zero, countOnBox: content, alignRight: alignCountOnBoxRight)
        addViewAndConstraints(view, toView: prevView, topConstant: 45)
        alignCountOnBoxRight = !alignCountOnBoxRight
        return view
    }
    
    fileprivate func addTabbedContent(_ content: Content.TabbedContent, previousView: UIView) -> UIView {
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
    
    fileprivate func leadLabel(_ string: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: "AktivGroteskCorpMedium-Regular", size: 16.0)
        label.textColor = UIColor.white
        //label.textAlignment = .Center
        label.text = string
        return label
    }
    
    fileprivate func listLabels(_ titleAndText: Content.TitleAndText) -> UIView {
        let listlabel = genericTextLabel("-")
        let container = UIView()
        var topConstraint = NSLayoutConstraint(item: listlabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        var leadConstraint = NSLayoutConstraint(item: listlabel, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        
        listlabel.setContentHuggingPriority(UILayoutPriorityRequired, for: UILayoutConstraintAxis.horizontal)
        listlabel.setContentHuggingPriority(UILayoutPriorityRequired, for: UILayoutConstraintAxis.vertical)
        listlabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(listlabel)
        
        NSLayoutConstraint.activate([topConstraint, leadConstraint])
        let mutString = NSMutableAttributedString()
        if titleAndText.title != nil {
            mutString.append(NSAttributedString(string: titleAndText.title!+"\n", attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorp-Light", size: 16.0)!]))
        }
        if titleAndText.text != nil {
            mutString.append(NSAttributedString(string: titleAndText.text!, attributes: [NSFontAttributeName:UIFont(name: "AktivGroteskCorp-Light", size: 16.0)!]))
        }
        
        let textlabel = genericTextLabel("")
        textlabel.attributedText = mutString
        topConstraint = NSLayoutConstraint(item: textlabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        leadConstraint = NSLayoutConstraint(item: textlabel, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: listlabel, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 10)
        let trailConstraint = NSLayoutConstraint(item: textlabel, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        let botConstraint = NSLayoutConstraint(item: textlabel, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        
        textlabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(textlabel)
        
        NSLayoutConstraint.activate([topConstraint, leadConstraint, botConstraint, trailConstraint])
        
        return container
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

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
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
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity == CGPoint.zero {
            return
        }
        
        let height = scrollView.bounds.height
        var target = targetContentOffset.pointee
        
        if target.y < height / 2 {
            target.y = 0
        } else if target.y < height {
            target.y = height
        }
        
        targetContentOffset.pointee = target
    }
    
    //file collectionview
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedContent.pdfs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ToolsCollectionViewCell
        let pdf = selectedContent.pdfs[(indexPath as NSIndexPath).row]
        cell.button.setTitle(pdf.title, for: UIControlState())
        return cell
    }
    
    @IBAction func documentAction(_ sender: UIButton) {
        let r = self.filesCollectionView.convert(sender.bounds, from: sender)
        if let indexPath = self.filesCollectionView.indexPathForItem(at: r.origin) {
            let pdf = selectedContent.pdfs[(indexPath as NSIndexPath).row]
            if let url = FileCache.getStoredFileURL(pdf.url) {
                let vc = UIDocumentInteractionController(url: url)
                vc.delegate = self
                vc.presentPreview(animated: true)
            }
        }
    }
    
    func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIView? {
        return nil
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showLogoView()
    }
    
    func documentInteractionControllerWillBeginPreview(_ controller: UIDocumentInteractionController) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.hideLogoView()
    }

}
