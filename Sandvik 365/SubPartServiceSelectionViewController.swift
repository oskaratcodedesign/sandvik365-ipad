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
    
    fileprivate var selectedSubPart: SubPartService!
    fileprivate var subPartsServices: [SubPartService]?
    
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var sectionScrollView: UIScrollView!
    @IBOutlet weak var sectionScrollViewContentView: UIView!
    @IBOutlet weak var lastSectionButton: SectionSelectionButton!
    
    @IBOutlet weak var subSectionTitleLabel: UILabel!
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var lastTrailingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as? ViewWithBGImage {
            view.setImageBG(self.selectedPartsAndServices.businessType.backgroundImageName)
        }
        sectionScrollView.delegate = self
        sectionTitleLabel.text = mainSectionTitle.uppercased()
        subSectionTitleLabel.text = selectedSectionTitle.uppercased()
        
        subPartsServices = selectedPartsAndServices.subPartsServices(mainSectionTitle, partServicesectionTitle: selectedSectionTitle)
        if let subParts = subPartsServices {
            var firstSectionButtonAdded = false
            
            for sp in subParts {
                if !selectedPartsAndServices.shouldSubPartServiceBeShown(sp) {
                    continue
                }
                
                if !firstSectionButtonAdded {
                    lastSectionButton.sectionButton.setTitle(sp.title.uppercased(), for: UIControlState())
                    lastSectionButton.sectionButton.addTarget(self, action:#selector(handleButtonSelect), for: .touchUpInside)
                    lastSectionButton.buttonMultiplierWidth = 0.9
                    firstSectionButtonAdded = true
                }
                else {
                    let selButton = SectionSelectionButton(frame: CGRect.zero)
                    selButton.sectionButton.setTitle(sp.title.uppercased(), for: UIControlState())
                    selButton.sectionButton.addTarget(self, action:#selector(handleButtonSelect), for: .touchUpInside)
                    
                    let topConstraint = NSLayoutConstraint(item: selButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: sectionScrollViewContentView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
                    let botConstraint = NSLayoutConstraint(item: selButton, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: sectionScrollViewContentView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
                    let trailConstraint = NSLayoutConstraint(item: selButton, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: sectionScrollViewContentView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
                    let leadConstraint = NSLayoutConstraint(item: selButton, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: lastSectionButton, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
                    let widthConstraint = NSLayoutConstraint(item: selButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: lastSectionButton, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
                    
                    selButton.translatesAutoresizingMaskIntoConstraints = false
                    sectionScrollViewContentView.addSubview(selButton)
                    NSLayoutConstraint.deactivate([lastTrailingConstraint])
                    NSLayoutConstraint.activate([topConstraint, botConstraint, trailConstraint, leadConstraint, widthConstraint])
                    lastTrailingConstraint = trailConstraint
                    selButton.buttonMultiplierWidth = lastSectionButton.buttonMultiplierWidth
                    lastSectionButton = selButton
                }
            }
        }
        rightButton.isHidden = true
        leftButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if sectionScrollView.bounds.size.width >= sectionScrollView.contentSize.width {
            leftButton.isHidden = true
            rightButton.isHidden = true
        }
        else {
            hideShowToggleButtons(sectionScrollView.contentOffset.x)
        }
    }
    
    func moveToNextPage(_ left: Bool) {
        
        let pageWidth:CGFloat = sectionScrollView.bounds.size.width
        let contentOffset:CGFloat = sectionScrollView.contentOffset.x
        
        let slideToX = contentOffset + (left ? -pageWidth : pageWidth)
        sectionScrollView.scrollRectToVisible(CGRect(x: slideToX, y: 0, width: pageWidth, height: sectionScrollView.bounds.height), animated: true)
        hideShowToggleButtons(slideToX)
    }
    
    func hideShowToggleButtons(_ nextX: CGFloat) {
        leftButton.isHidden = false
        rightButton.isHidden = false
        if nextX <= 0 {
            leftButton.isHidden = true
        }
        else if nextX + sectionScrollView.bounds.size.width  >= sectionScrollView.contentSize.width {
            rightButton.isHidden = true
        }
    }
    
    @IBAction func toggleRight(_ sender: UIButton) {
        moveToNextPage(false)
    }
    
    @IBAction func toggleLeft(_ sender: UIButton) {
        moveToNextPage(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func handleButtonSelect(_ sender: UIButton) {
        if let selectedSectionTitle = sender.titleLabel?.text {
            if let subParts = subPartsServices {
                for sp in subParts {
                    if sp.title.caseInsensitiveCompare(selectedSectionTitle) == .orderedSame {
                        selectedSubPart = sp
                        performSegue(withIdentifier: "ShowSubPartServiceContentViewController", sender: self)
                        return
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSubPartServiceContentViewController" {
            if let vc = segue.destination as? SubPartServiceContentViewController {
                SubPartServiceSelectionViewController.setSubPartServiceContentViewController(vc, selectedPartsAndServices: selectedPartsAndServices, mainSectionTitle: mainSectionTitle, selectedSectionTitle: selectedSectionTitle, navTitle: self.navigationItem.title, selectedSubPart: selectedSubPart)
            }
        }
    }
    
    static func setSubPartServiceContentViewController(_ vc: SubPartServiceContentViewController, selectedPartsAndServices: PartsAndServices, mainSectionTitle: String, selectedSectionTitle: String, navTitle: String?, selectedSubPart: SubPartService) {
        vc.selectedPartsAndServices = selectedPartsAndServices
        vc.selectedContent = selectedSubPart.content
        vc.navigationItem.title = String(format: "%@ | %@ | %@", navTitle!, mainSectionTitle.uppercased(), selectedSectionTitle.uppercased())
    }

}
