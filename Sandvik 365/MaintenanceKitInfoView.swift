//
//  MaintenanceKitInfoView.swift
//  Sandvik 365
//
//  Created by Oskar Hakansson on 02/09/16.
//  Copyright © 2016 Commind. All rights reserved.
//

class MaintenanceKitInfoCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var quantity: UILabel!
}

class MaintenanceKitInfoView: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var name: UILabel!
    
    var data: MaintenanceServiceKitParent? {
        didSet {
            self.setData()
        }
    }
    
    private func setData() {
        self.name.text = data!.description
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.components.count ?? 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MaintenanceKitInfoCell") as! MaintenanceKitInfoCell
        cell.backgroundColor = UIColor.clearColor()
        cell.name.text = data!.components[indexPath.row].description
        if let q = data!.components[indexPath.row].quantity {
            cell.quantity.text = String(q)
        }
        return cell
    }
    
    @IBAction func closeAction(sender: UIButton) {
        self.hidden = true
    }
}
