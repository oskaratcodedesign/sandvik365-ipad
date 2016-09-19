//
//  PartsAndServicesViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 25/08/15.
//  Copyright (c) 2015 Commind. All rights reserved.
//

import UIKit

class PartsAndServicesViewController: UIViewController, SelectionWheelDelegate {

    @IBOutlet weak var selectionWheel: SelectionWheel!
    @IBOutlet weak var sectionLabel: UILabel!
    var selectedPartsAndServices: PartsAndServices!
    var mainTitle: String?
    fileprivate var selectedSectionTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as? ViewWithBGImage {
            view.setImageBG(self.selectedPartsAndServices.businessType.backgroundImageName)
        }
        selectionWheel.sectionTitles = selectedPartsAndServices.mainSectionTitles()
        selectionWheel.delegate = self
        sectionLabel.text = self.mainTitle ?? self.navigationItem.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSelectSection(_ sectionTitle: String) {
        
        selectedSectionTitle = sectionTitle
        if let index = self.selectedPartsAndServices.businessType.interActiveTools?.index(where: { $0.title.caseInsensitiveCompare(sectionTitle) == .orderedSame}) {
            let tool = self.selectedPartsAndServices.businessType.interActiveTools![index]
            if ((tool.selectionInput as? SelectionInput) != nil) {
                performSegue(withIdentifier: "ShowRoiSelectionViewController", sender: self)
            }
            else if tool == .serviceKitQuantifier {
                self.performSegue(withIdentifier: "ServiceKitQuantifierViewController", sender: self)
            }
        }
        else if self.selectedPartsAndServices.businessType.mediaCenterTitle?.caseInsensitiveCompare(sectionTitle) == .orderedSame {
            performSegue(withIdentifier: "ShowVideoCenterViewController", sender: self)
        }
        else if self.selectedPartsAndServices.businessType.interActiveToolsTitle?.caseInsensitiveCompare(sectionTitle) == .orderedSame {
            performSegue(withIdentifier: "ShowInterActiveToolsViewController", sender: self)
        }
        else {
            performSegue(withIdentifier: "ShowPartServiceSelectionViewController", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPartServiceSelectionViewController" {
            if let vc = segue.destination as? PartServiceSelectionViewController {
                PartsAndServicesViewController.setPartServiceSelectionViewController(vc, selectedPartsAndServices: selectedPartsAndServices, mainSectionTitle: selectedSectionTitle, navTitle: self.navigationItem.title)
            }
        }
        else if segue.identifier == "ShowVideoCenterViewController" {
            if let vc = segue.destination as? VideoCenterViewController {
                vc.selectedBusinessType = self.selectedPartsAndServices.businessType
                vc.navigationItem.title = String(format: "%@ | %@", self.navigationItem.title!, vc.selectedBusinessType.mediaCenterTitle!.uppercased())
            }
        }
        else if segue.identifier == "ShowRoiSelectionViewController" {
            if let vc = segue.destination as? RoiSelectionViewController {
                let bType = selectedPartsAndServices.businessType
                if let index = bType.interActiveTools?.index(where: { $0.title.caseInsensitiveCompare(selectedSectionTitle) == .orderedSame}) {
                    let interActiveTool = bType.interActiveTools![index]
                    vc.selectedBusinessType = bType
                    vc.selectedInput = interActiveTool.selectionInput as! SelectionInput
                    vc.navigationItem.title = String(format: "%@ | %@", self.navigationItem.title!, interActiveTool.title.uppercased())
                }
            }
        }
        else if segue.identifier == "ServiceKitQuantifierViewController" {
            if let vc = segue.destination as? ServiceKitQuantifierViewController {
                vc.selectedBusinessType = .all
                let tool: BusinessType.InterActiveTool = .serviceKitQuantifier
                vc.navigationItem.title = String(format: "%@ | %@", self.navigationItem.title!, tool.title.uppercased())
            }
        }
    }
    
    static func setPartServiceSelectionViewController(_ vc: PartServiceSelectionViewController, selectedPartsAndServices: PartsAndServices, mainSectionTitle: String, navTitle: String?) {
        vc.selectedPartsAndServices = selectedPartsAndServices
        vc.mainSectionTitle = mainSectionTitle
        vc.navigationItem.title = navTitle
    }

}
