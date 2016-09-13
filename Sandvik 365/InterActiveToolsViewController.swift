//
//  InterActiveToolsViewController.swift
//  sandvik-365-internal
//
//  Created by Oskar Hakansson on 25/01/16.
//  Copyright © 2016 Oskar Hakansson. All rights reserved.
//

import UIKit

class InterActiveToolsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    let data: [BusinessType.InterActiveTool] = BusinessType.All.interActiveTools!
    private var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        self.navigationItem.title = "SANDVIK 365 – INTERACTIVE TOOLS"
        super.viewDidLoad()
        if let view = self.view as? ViewWithBGImage {
            view.setImageBG(BusinessType.All.backgroundImageName)
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ToolsCollectionViewCell
        let tool = self.data[indexPath.row]
        cell.button.setTitle(tool.title, forState: .Normal)
        cell.button.setBackgroundImage(tool.defaultImage, forState: .Normal)
        cell.button.setBackgroundImage(tool.highlightImage, forState: .Highlighted)
        if ((tool.selectionInput as? SelectionInput) != nil) {
            cell.button.addTarget(self, action: #selector(roiButtonClick), forControlEvents: .TouchUpInside)
        }
        else if tool == .ServiceKitQuantifier {
            cell.button.addTarget(self, action: #selector(serviceKitButtonClick), forControlEvents: .TouchUpInside)
        }
        return cell
    }
    
    func roiButtonClick(sender: UIButton) {
        self.performSegueWithIdentifier("RoiSelectionViewController", sender: sender)
    }
    
    func serviceKitButtonClick(sender: UIButton) {
        self.performSegueWithIdentifier("ServiceKitQuantifierViewController", sender: sender)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RoiSelectionViewController" {
            if let vc = segue.destinationViewController as? RoiSelectionViewController {
                if let b = sender as? UIButton {
                    let r = self.collectionView.convertRect(b.bounds, fromView: b)
                    if let indexPath = self.collectionView.indexPathForItemAtPoint(r.origin) {
                        let input = self.data[indexPath.row]
                        vc.selectedInput = input.selectionInput as! SelectionInput
                        vc.selectedBusinessType = .All
                        vc.navigationItem.title = String(format: "%@ | %@", self.navigationItem.title!, input.title.uppercaseString)
                    }
                }
            }
        }
        else if segue.identifier == "ServiceKitQuantifierViewController" {
            if let vc = segue.destinationViewController as? ServiceKitQuantifierViewController {
                if let b = sender as? UIButton {
                    let r = self.collectionView.convertRect(b.bounds, fromView: b)
                    if let indexPath = self.collectionView.indexPathForItemAtPoint(r.origin) {
                        let input = self.data[indexPath.row]
                        vc.selectedBusinessType = .All
                        vc.navigationItem.title = String(format: "%@ | %@", self.navigationItem.title!, input.title.uppercaseString)
                    }
                }
            }
        }
    }
}
