//
//  VideoCenterViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 11/01/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import UIKit

class VideoCenterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{

    @IBOutlet weak var collectionView: UICollectionView!
    var selectedBusinessType: BusinessType!
    private var videos: [Video]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as? ViewWithBGImage {
            view.setImageBG(self.selectedBusinessType.backgroundImageName)
        }
        self.videos = self.selectedBusinessType.videos?.sort({ (v1: Video, v2: Video) -> Bool in
            v1.title.caseInsensitiveCompare(v2.title) == .OrderedAscending
        })
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! VideoCell
        let video = self.videos[indexPath.row]
        cell.videoButton.imageView.image = UIImage(named: video.imageName)
        cell.videoButton.titleLabel.text = video.title
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "VideoViewController" {
            if let vc = segue.destinationViewController as? VideoViewController {
                if let indexPath = self.collectionView.indexPathsForSelectedItems()?.first {
                    vc.videoUrl = self.videos[indexPath.row].videoUrl
                }
            }
        }
    }
}