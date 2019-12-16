//
//  IssueListCell.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 16/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit

class IssueListCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var issuesCountLabel: UILabel!
    
    static let reuseId = "issueListCell"
    
    private lazy var birthDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    func setup(with issue: Issue) {
        
        nameLabel.update(withNameFrom: issue)
        birthDateLabel.update(withBirthDateFrom: issue, formatter: birthDateFormatter)
        issuesCountLabel.update(withCountFrom: issue)
    }
}
