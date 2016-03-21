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
    let data: [BusinessType.InterActiveTools] = BusinessType.All.interActiveTools!
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
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RoiSelectionViewController" {
            if let vc = segue.destinationViewController as? RoiSelectionViewController {
                if let b = sender as? UIButton {
                    let r = self.collectionView.convertRect(b.bounds, fromView: b)
                    if let indexPath = self.collectionView.indexPathForItemAtPoint(r.origin) {
                        let input = self.data[indexPath.row]
                        vc.selectedInput = input.selectionInput
                        vc.selectedBusinessType = .All
                        vc.navigationItem.title = String(format: "%@ | %@", self.navigationItem.title!, input.title.uppercaseString)
                    }
                }
            }
        }
    }
}
