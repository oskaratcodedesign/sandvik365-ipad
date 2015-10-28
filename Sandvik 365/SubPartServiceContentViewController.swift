//
//  SubPartServiceContentViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 28/10/15.
//  Copyright © 2015 Commind. All rights reserved.
//

import UIKit

class SubPartServiceContentViewController: UIViewController {

    var selectedPartsAndServices: PartsAndServices!
    var selectedSubPartService: SubPartService!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let content = selectedSubPartService.content
        if var title = content.objectForKey("title") as? String {
            if let subtitle = content.objectForKey("subTitle") as? String {
                title += "\n" + subtitle
            }
            titleLabel.text = title
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
