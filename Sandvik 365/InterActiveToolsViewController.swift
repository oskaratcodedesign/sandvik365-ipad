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
    
    override func viewDidLoad() {
        self.navigationItem.title = "SANDVIK 365 – INTERACTIVE TOOLS"
        super.viewDidLoad()
        if let view = self.view as? ViewWithBGImage {
            view.setImageBG("Cover-frederik")
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
        let title = self.data[indexPath.row].title
        cell.titleLabel.text = title
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("RoiSelectionViewController", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RoiSelectionViewController" {
            if let vc = segue.destinationViewController as? RoiSelectionViewController {
                if let index = collectionView.indexPathsForSelectedItems()?.first?.row {
                    let input = self.data[index]
                    vc.selectedInput = input.selectionInput
                    vc.selectedBusinessType = .All
                    vc.navigationItem.title = String(format: "%@ | %@", self.navigationItem.title!, input.title.uppercaseString)
                }
            }
        }
    }
}
