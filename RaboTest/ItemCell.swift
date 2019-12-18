//
//  ItemCell.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 18/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit

/// Displays a single value and title of a line of a prased CSV
class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    static let reuseId = "itemCell"
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        valueLabel.font = UIFont.systemFont(ofSize: 15)
    }
    
    /// Sets up cell. Title: name of field. Value: Value of field
    func setup(title: String, value: Any?) {
        
        titleLabel.text = title
        if let _value = value {
            valueLabel.text = String.from(value: _value)
        }
        else {
            valueLabel.text = nil
        }
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        titleLabel.text = nil
        valueLabel.text = nil
    }
}
