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
    let data: [(String, AnyObject)] = [("Rock drill upgrade simulator", ROIRockDrillInput())]
    
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
        let title = self.data[indexPath.row].0
        cell.titleLabel.text = title
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let object = self.data[indexPath.row]
        if object.1 is ROIRockDrillInput {
            self.performSegueWithIdentifier("RoiSelectionViewController", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RoiSelectionViewController" {
            if let vc = segue.destinationViewController as? RoiSelectionViewController {
                if let input = self.data[collectionView.indexPathsForSelectedItems()!.first!.row].1 as? ROIRockDrillInput {
                    vc.selectedInput = input
                }
            }
        }
    }
}
