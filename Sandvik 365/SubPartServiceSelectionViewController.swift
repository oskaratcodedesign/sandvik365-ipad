//
//  SubServiceViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 16/10/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import UIKit

class SubPartServiceSelectionViewController: UIViewController, UIScrollViewDelegate {

    var selectedPartsAndServices: PartsAndServices!
    var mainSectionTitle: String!
    var selectedSectionTitle: String!
    
    private var selectedSubPart: SubPartService!
    private var subPartsServices: [SubPartService]?
    
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var sectionScrollView: UIScrollView!
    @IBOutlet weak var sectionScrollViewContentView: UIView!
    @IBOutlet weak var lastSectionButton: SectionSelectionButton!
    private var lastTrailingConstraint: NSLayoutConstraint? = nil
    
    @IBOutlet weak var subSectionTitleLabel: UILabel!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as? ViewWithBGImage {
            view.setImageBG(self.selectedPartsAndServices.businessType.backgroundImageName)
        }
        sectionScrollView.delegate = self
        sectionTitleLabel.text = mainSectionTitle.uppercaseString
        subSectionTitleLabel.text = selectedSectionTitle.uppercaseString
        
        subPartsServices = selectedPartsAndServices.subPartsServices(mainSectionTitle, partServicesectionTitle: selectedSectionTitle)
        sectionScrollView.contentOffset.x = 200
        if let subParts = subPartsServices {
            if let firstItem = subParts.first {
                lastSectionButton.sectionButton.setTitle(firstItem.title.uppercaseString, forState: .Normal)
                lastSectionButton.sectionButton.addTarget(self, action: "handleButtonSelect:", forControlEvents: .TouchUpInside)
                lastSectionButton.buttonMultiplierWidth = 0.9
                for i in 1...subParts.count-1 {
                    let ps = subParts[i]
                    let selButton = SectionSelectionButton(frame: CGRectZero)
                    selButton.sectionButton.setTitle(ps.title.uppercaseString, forState: .Normal)
                    selButton.sectionButton.addTarget(self, action: "handleButtonSelect:", forControlEvents: .TouchUpInside)
                    
                    let topConstraint = NSLayoutConstraint(item: selButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: sectionScrollViewContentView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
                    let botConstraint = NSLayoutConstraint(item: selButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: sectionScrollViewContentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
                    let trailConstraint = NSLayoutConstraint(item: selButton, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: sectionScrollViewContentView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
                    let leadConstraint = NSLayoutConstraint(item: selButton, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: lastSectionButton, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
                    let widthConstraint = NSLayoutConstraint(item: selButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: lastSectionButton, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
                    
                    selButton.translatesAutoresizingMaskIntoConstraints = false
                    sectionScrollViewContentView.addSubview(selButton)
                    if lastTrailingConstraint != nil {
                        NSLayoutConstraint.deactivateConstraints([lastTrailingConstraint!])
                    }
                    NSLayoutConstraint.activateConstraints([topConstraint, botConstraint, trailConstraint, leadConstraint, widthConstraint])
                    lastTrailingConstraint = trailConstraint
                    selButton.buttonMultiplierWidth = lastSectionButton.buttonMultiplierWidth
                    lastSectionButton = selButton
                }
            }
        }
        rightButton.hidden = true
        leftButton.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if sectionScrollView.bounds.size.width > sectionScrollView.contentSize.width {
            leftButton.hidden = true
            rightButton.hidden = true
        }
        else {
            hideShowToggleButtons(sectionScrollView.contentOffset.x)
        }
    }
    
    func moveToNextPage(left: Bool) {
        
        let pageWidth:CGFloat = sectionScrollView.bounds.size.width
        let contentOffset:CGFloat = sectionScrollView.contentOffset.x
        
        let slideToX = contentOffset + (left ? -pageWidth : pageWidth)
        sectionScrollView.scrollRectToVisible(CGRectMake(slideToX, 0, pageWidth, sectionScrollView.bounds.height), animated: true)
        hideShowToggleButtons(slideToX)
    }
    
    func hideShowToggleButtons(nextX: CGFloat) {
        leftButton.hidden = false
        rightButton.hidden = false
        if nextX <= 0 {
            leftButton.hidden = true
        }
        else if nextX + sectionScrollView.bounds.size.width  >= sectionScrollView.contentSize.width {
            rightButton.hidden = true
        }
    }
    
    @IBAction func toggleRight(sender: UIButton) {
        moveToNextPage(false)
    }
    
    @IBAction func toggleLeft(sender: UIButton) {
        moveToNextPage(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func handleButtonSelect(sender: UIButton) {
        if let selectedSectionTitle = sender.titleLabel?.text {
            if let subParts = subPartsServices {
                for sp in subParts {
                    if sp.title.caseInsensitiveCompare(selectedSectionTitle) == .OrderedSame {
                        selectedSubPart = sp
                        performSegueWithIdentifier("ShowSubPartServiceContentViewController", sender: self)
                        return
                    }
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowSubPartServiceContentViewController" {
            if let vc = segue.destinationViewController as? SubPartServiceContentViewController {
                vc.selectedPartsAndServices = selectedPartsAndServices
                vc.selectedContent = selectedSubPart.content
                vc.navigationItem.title = self.navigationItem.title
            }
        }
    }

}
