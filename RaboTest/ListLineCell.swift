//
//  ListLineCell.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 18/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit

/// Encapsulates displaying an entire line of a parsed CSV
class ListLineCell: UITableViewCell {
    
    static let reuseId = "lineCell"
    
    private(set) var lineController: LineViewController!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        separatorInset = .zero
        
        if lineController == nil {
            
            lineController = LineViewController.controller()
            lineController.view.frame = CGRect(origin: CGPoint.zero, size: contentView.bounds.size)
            lineController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            contentView.addSubview(lineController.view)
        }
        
        accessibilityIdentifier = "line.table.csv"
    }
    
    /// Sets up cell with a line from parsed CSV file, optionally with headers
    func setup(values: CSVLine, headers: [String]) {
        
        lineController.headers = headers
        lineController.line = values
    }

    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        lineController.line = [:]
        lineController.headers = []
    }
}
