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
    var sectionTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var content = selectedPartsAndServices.subPartContent(sectionTitle)
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
