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
    let data: [BusinessType.InterActiveTool] = BusinessType.all.interActiveTools!
    fileprivate var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        self.navigationItem.title = "SANDVIK 365 – INTERACTIVE TOOLS"
        super.viewDidLoad()
        if let view = self.view as? ViewWithBGImage {
            view.setImageBG(BusinessType.all.backgroundImageName)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ToolsCollectionViewCell
        let tool = self.data[(indexPath as NSIndexPath).row]
        cell.button.setTitle(tool.title, for: UIControlState())
        cell.button.setBackgroundImage(tool.defaultImage, for: UIControlState())
        cell.button.setBackgroundImage(tool.highlightImage, for: .highlighted)
        if ((tool.selectionInput as? SelectionInput) != nil) {
            cell.button.addTarget(self, action: #selector(roiButtonClick), for: .touchUpInside)
        }
        else if tool == .serviceKitQuantifier {
            cell.button.addTarget(self, action: #selector(serviceKitButtonClick), for: .touchUpInside)
        }
        return cell
    }
    
    func roiButtonClick(_ sender: UIButton) {
        self.performSegue(withIdentifier: "RoiSelectionViewController", sender: sender)
    }
    
    func serviceKitButtonClick(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ServiceKitQuantifierViewController", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RoiSelectionViewController" {
            if let vc = segue.destination as? RoiSelectionViewController {
                if let b = sender as? UIButton {
                    let r = self.collectionView.convert(b.bounds, from: b)
                    if let indexPath = self.collectionView.indexPathForItem(at: r.origin) {
                        let input = self.data[(indexPath as NSIndexPath).row]
                        vc.selectedInput = input.selectionInput as! SelectionInput
                        vc.selectedBusinessType = .all
                        vc.navigationItem.title = String(format: "%@ | %@", self.navigationItem.title!, input.title.uppercased())
                    }
                }
            }
        }
        else if segue.identifier == "ServiceKitQuantifierViewController" {
            if let vc = segue.destination as? ServiceKitQuantifierViewController {
                if let b = sender as? UIButton {
                    let r = self.collectionView.convert(b.bounds, from: b)
                    if let indexPath = self.collectionView.indexPathForItem(at: r.origin) {
                        let input = self.data[(indexPath as NSIndexPath).row]
                        vc.selectedBusinessType = .all
                        vc.navigationItem.title = String(format: "%@ | %@", self.navigationItem.title!, input.title.uppercased())
                    }
                }
            }
        }
    }
}
