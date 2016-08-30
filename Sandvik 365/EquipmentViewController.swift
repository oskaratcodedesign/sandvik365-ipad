//
//  EquipmentViewController.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 29/08/16.
//  Copyright © 2016 Commind. All rights reserved.
//

import UIKit

class EquipmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EqFoooterDelegate {
    private var addedServiceKitData = [ServiceKitData]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: EqFoooterView!
    override func viewDidLoad() {
        super.viewDidLoad()
        footerView.configureView(addedServiceKitData.isEmpty)
        footerView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedServiceKitData.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let  cell = tableView.dequeueReusableCellWithIdentifier("EqStandardCell") as! EqStandardTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height + 60, 0.0)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.tableView.contentInset = UIEdgeInsetsZero
    }
    
    func didAddSerialNo(textField: UITextField) {
        if let text = textField.text {
            let data = ServiceKitData()
            self.addedServiceKitData.append(data)
            self.tableView.reloadData()
            textField.text = ""
        }
    }
    
}
