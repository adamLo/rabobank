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
        
        displayName(from: issue)
        displayBirthDate(from: issue)
        displayIssuesCount(from: issue)
    }
    
    private func displayName(from issue: Issue) {
        
        var name = "N/A"
        if let _surName = issue.surName {
            name = _surName
        }
        if let _firstName = issue.firstName {
            if issue.surName != nil {
                name += ", "
            }
            name += _firstName
        }
        nameLabel.text = "\(NSLocalizedString("Name: ", comment: "Name field prefix")) \(name)"
    }
    
    private func displayBirthDate(from issue: Issue) {
        
        var birthDateString = NSLocalizedString("Birth Date: ", comment: "Birth date field pefix")
        if let _date = issue.birthDate {
            birthDateString += birthDateFormatter.string(from: _date)
        }
        else {
            birthDateString += "N/A"
        }
        birthDateLabel.text = birthDateString
    }

    private func displayIssuesCount(from issue: Issue) {
        
        issuesCountLabel.text = String(format: NSLocalizedString("Issues count: %ld", comment: "Issues cound display format"), issue.issueCount)
    }
}
