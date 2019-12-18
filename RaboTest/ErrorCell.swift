//
//  ErrorCell.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 18/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit

class ErrorCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    
    static let reuseId = "errorCell"
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    func setup(error: Error) {
        
        messageLabel.text = error.localizedDescription
    }

    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        messageLabel.text = nil
    }
}
