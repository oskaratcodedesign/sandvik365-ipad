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
    fileprivate var selectedSectionTitle: String!
    fileprivate var partsServices: [PartService]?
    fileprivate var selectedPartService: PartService!
    
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
        sectionTitleLabel.text = mainSectionTitle.uppercased()
        if let partsServices = selectedPartsAndServices.partsServices(mainSectionTitle) {
            self.partsServices = partsServices
            var firstSectionButtonAdded = false
            for ps in partsServices {
                if !selectedPartsAndServices.shouldPartServiceBeShown(ps) {
                    continue
                }
                
                if !firstSectionButtonAdded {
                    lastSectionButton.sectionButton.setTitle(ps.title.uppercased(), for: UIControlState())
                    lastSectionButton.sectionButton.addTarget(self, action:#selector(handleButtonSelect(_:)), for: .touchUpInside)
                    sectionDescriptionLabel.text = ps.description
                    lastSectionButton.buttonMultiplierWidth = 0.5
                    firstSectionButtonAdded = true
                }
                else {
                    let selButton = SectionSelectionButton(frame: CGRect.zero)
                    selButton.sectionButton.setTitle(ps.title.uppercased(), for: UIControlState())
                    selButton.sectionButton.addTarget(self, action:#selector(handleButtonSelect(_:)), for: .touchUpInside)
                    
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
    
    func handleButtonSelect(_ button :UIButton) {
        if let selectedSectionTitle = button.titleLabel?.text {
            self.selectedSectionTitle = selectedSectionTitle
            if let partService = partsServices {
                for ps in partService {
                    if ps.title.caseInsensitiveCompare(selectedSectionTitle) == .orderedSame {
                        selectedPartService = ps
                        if ps.content != nil {
                            performSegue(withIdentifier: "ShowSubPartServiceContentViewController", sender: self)
                        }
                        else if ps.subPartsServices != nil {
                            performSegue(withIdentifier: "ShowSubPartServiceSelectionViewController", sender: self)
                        }
                        return
                    }
                }
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let pageWidth:CGFloat = sectionScrollView.bounds.size.width
        let currentPage = Int(floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1)
        if let partsServices = partsServices {
            if currentPage < partsServices.count {
                sectionDescriptionLabel.text = partsServices[currentPage].description
            }
        }
        self.rightButton.isEnabled = true
        self.leftButton.isEnabled = true
    }
    
    func moveToNextPage(_ left: Bool) {
        let pageWidth = sectionScrollView.bounds.size.width
        let contentOffset = sectionScrollView.contentOffset.x
        
        let slideToX = contentOffset + (left ? -pageWidth : pageWidth)
        sectionScrollView.scrollRectToVisible(CGRect(x: slideToX, y: 0, width: pageWidth, height: sectionScrollView.bounds.height), animated: true)
        hideShowToggleButtons(slideToX)
        self.rightButton.isEnabled = false
        self.leftButton.isEnabled = false
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSubPartServiceSelectionViewController" {
            if let vc = segue.destination as? SubPartServiceSelectionViewController {
                PartServiceSelectionViewController.setSubPartServiceSelectionViewController(vc, selectedPartsAndServices: selectedPartsAndServices, mainSectionTitle: mainSectionTitle, selectedSectionTitle: selectedSectionTitle, navTitle: self.navigationItem.title)
            }
        }
        else if segue.identifier == "ShowSubPartServiceContentViewController" {
            if let vc = segue.destination as? SubPartServiceContentViewController {
                vc.selectedPartsAndServices = selectedPartsAndServices
                vc.selectedContent = selectedPartService.content
                vc.navigationItem.title = String(format: "%@ | %@", self.navigationItem.title!, selectedSectionTitle.uppercased())
            }
        }
    }
    
    static func setSubPartServiceSelectionViewController(_ vc: SubPartServiceSelectionViewController, selectedPartsAndServices: PartsAndServices, mainSectionTitle: String, selectedSectionTitle: String, navTitle: String?) {
        vc.selectedPartsAndServices = selectedPartsAndServices
        vc.mainSectionTitle = mainSectionTitle
        vc.selectedSectionTitle = selectedSectionTitle
        vc.navigationItem.title = navTitle
    }

}
