//
//  ServiceSelectionViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 16/10/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import UIKit

class PartServiceSelectionViewController: UIViewController, UIScrollViewDelegate {

    var selectedPartsAndServices: PartsAndServices!
    var mainSectionTitle: String!
    private var selectedSectionTitle: String!
    private var partsServices: [PartService] = []
    
    @IBOutlet weak var sectionSelectionView: UIView!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var sectionScrollView: UIScrollView!
    @IBOutlet weak var sectionDescriptionLabel: UILabel!
    
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var sectionScrollViewContentView: UIView!
    @IBOutlet weak var lastSectionButton: SectionSelectionButton!
    @IBOutlet weak var lastTrailingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as? ViewWithBGImage {
            view.setImageBG(self.selectedPartsAndServices.businessType.backgroundImageName)
        }
        sectionScrollView.delegate = self
        sectionTitleLabel.text = mainSectionTitle.uppercaseString
        if let partsServices = selectedPartsAndServices.partsServices(mainSectionTitle) {
            self.partsServices = partsServices
            if let firstItem = partsServices.first {
                lastSectionButton.sectionButton.setTitle(firstItem.title.uppercaseString, forState: .Normal)
                lastSectionButton.sectionButton.addTarget(self, action: "handleButtonSelect:", forControlEvents: .TouchUpInside)
                sectionDescriptionLabel.text = firstItem.description
                lastSectionButton.buttonMultiplierWidth = 0.5
                for i in 1...partsServices.count-1 {
                    let ps = partsServices[i]
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
                    NSLayoutConstraint.deactivateConstraints([lastTrailingConstraint])
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
    
    func handleButtonSelect(button :UIButton) {
        selectedSectionTitle = button.titleLabel?.text
        performSegueWithIdentifier("ShowSubPartServiceSelectionViewController", sender: self)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let pageWidth:CGFloat = sectionScrollView.bounds.size.width
        let currentPage = Int(floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1)
        if currentPage < partsServices.count {
            sectionDescriptionLabel.text = partsServices[currentPage].description
        }
    }
    
    func moveToNextPage(left: Bool) {
        let pageWidth = sectionScrollView.bounds.size.width
        let contentOffset = sectionScrollView.contentOffset.x
        
        let slideToX = contentOffset + (left ? -pageWidth : pageWidth)
        sectionScrollView.scrollRectToVisible(CGRectMake(slideToX, 0, pageWidth, sectionScrollView.bounds.height), animated: true)
        hideShowToggleButtons(slideToX)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowSubPartServiceSelectionViewController" {
            if let vc = segue.destinationViewController as? SubPartServiceSelectionViewController {
                vc.selectedPartsAndServices = selectedPartsAndServices
                vc.mainSectionTitle = mainSectionTitle
                vc.selectedSectionTitle = selectedSectionTitle
                vc.navigationItem.title = String(format: "%@ | %@", self.navigationItem.title!, selectedSectionTitle.uppercaseString)
            }
        }
    }

}
