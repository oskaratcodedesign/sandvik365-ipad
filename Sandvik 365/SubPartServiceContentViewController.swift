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
        if let html = content.objectForKey("content") as? NSArray {
            for part in html {
                if let type = part.objectForKey("type") as? String {
                    if type == "lead", let value = part.objectForKey("value") as? String {
                        addLead(value)
                    }
                    else if type == "body", let value = part.objectForKey("value") as? String {
                        addBody(value)
                    }
                    else if type == "key-feature-list", let value = part.objectForKey("value") as? NSDictionary {
                        addKeyFeatureList(value)
                    }
                    else if type == "columns", let value = part.objectForKey("value") as? NSDictionary {
                        addColumns(value)
                    }
                    else if type == "tabbed-content", let value = part.objectForKey("value") as? NSDictionary {
                        addTabbedContent(value)
                    }
                }
            }
        }
    }
    
    private func addLead(string: String) {
        
        //add picture
    }
    
    private func addBody(string: String) {
        
    }
    
    private func addKeyFeatureList(dic: NSDictionary) {
        
    }
    
    private func addColumns(dic: NSDictionary) {
        
    }
    
    private func addTabbedContent(dic: NSDictionary) {
        
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
