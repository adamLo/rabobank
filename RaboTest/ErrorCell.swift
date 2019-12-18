//
//  ErrorCell.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 18/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit

/// Displays an error occured during loading and parsing CSV file
class ErrorCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    
    static let reuseId = "errorCell"
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        selectionStyle = .none
        messageLabel.font = UIFont.systemFont(ofSize: 15)
    }

    /// Sets up cell with an error instance
    func setup(error: Error) {
        
        messageLabel.text = error.localizedDescription
    }

    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        messageLabel.text = nil
    }
}
