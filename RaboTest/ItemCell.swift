//
//  ItemCell.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 18/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    static let reuseId = "itemCell"
    
    func setup(title: String, value: Any?) {
        
        titleLabel.text = title
        valueLabel.text = "\(value ?? "X")"
    }
}
