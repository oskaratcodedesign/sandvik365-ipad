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
    
    var data: MaintenanceOfferData? {
        didSet {
            self.setData()
        }
    }
    
    fileprivate func setData() {
        self.name.text = data!.description
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.maintenanceServiceKitParent.components.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MaintenanceKitInfoCell") as! MaintenanceKitInfoCell
        cell.backgroundColor = UIColor.clear
        cell.name.text = data!.maintenanceServiceKitParent.components[(indexPath as NSIndexPath).row].description
        if let q = data!.maintenanceServiceKitParent.components[(indexPath as NSIndexPath).row].quantity {
            cell.quantity.text = String(q)
        }
        return cell
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.isHidden = true
    }
}
