//
//  ToolsCollectionViewCell.swift
//  sandvik-365-internal
//
//  Created by Oskar Hakansson on 26/01/16.
//  Copyright © 2016 Oskar Hakansson. All rights reserved.
//

import UIKit

class ToolsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var button: UIButton! {
        didSet {
            self.button.titleLabel?.numberOfLines = 3
            self.button.titleLabel?.textAlignment = .center
        }
    }
}
