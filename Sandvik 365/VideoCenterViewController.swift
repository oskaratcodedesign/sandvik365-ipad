//
//  VideoCenterViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 11/01/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import UIKit

class VideoCenterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, VideoButtonDelegate
{

    @IBOutlet weak var collectionView: UICollectionView!
    var selectedBusinessType: BusinessType!
    fileprivate var videos: [Video]!
    @IBOutlet weak var gradientView: GradientHorizontalView!
    
    override func viewDidLoad() {
        if self.selectedBusinessType == .all {
            self.navigationItem.title = "SANDVIK 365 – VIDEOS & ANIMATIONS"
        }
        super.viewDidLoad()
        if let view = self.view as? ViewWithBGImage {
            view.setImageBG(self.selectedBusinessType.backgroundImageName)
        }
        self.videos = self.selectedBusinessType.videos
        sortVideos()
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let xOffset = self.collectionView.contentSize.width
        let width = self.collectionView.frame.size.width
        if xOffset > width {
            self.gradientView.isHidden = false
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VideoCell
        let video = self.videos[(indexPath as NSIndexPath).row]
        cell.videoButton.configure(video, delegate: self)
        return cell
    }
    
    func favoriteAction(_ video: Video) {
        let currentIndex = self.videos.index(of: video)
        sortVideos()
        let nextIndex = self.videos.index(of: video)
        if currentIndex != nil && nextIndex != nil {
            self.collectionView.moveItem(at: IndexPath(row: currentIndex!, section: 0), to: IndexPath(row: nextIndex!, section: 0))
        }
    }
    
    fileprivate func sortVideos() {
        let favorites = self.videos.filter({$0.isFavorite}).sorted(by: { (v1: Video, v2: Video) -> Bool in
            v1.title!.caseInsensitiveCompare(v2.title!) == .orderedAscending
        })
        let rest = self.videos.filter({!$0.isFavorite}).sorted(by: { (v1: Video, v2: Video) -> Bool in
            v1.title!.caseInsensitiveCompare(v2.title!) == .orderedAscending
        })
        self.videos = favorites + rest
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "VideoViewController" {
            if let vc = segue.destination as? VideoViewController {
                if let indexPath = self.collectionView.indexPathsForSelectedItems?.first {
                    vc.videoUrl = self.videos[(indexPath as NSIndexPath).row].videoUrl
                }
            }
        }
    }
}
