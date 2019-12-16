//
//  IssueCellLabels.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 16/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func update(withNameFrom issue: Issue) {
        
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
        
        text = "\(NSLocalizedString("Name: ", comment: "Name field prefix")) \(name)"
    }
    
    func update(withBirthDateFrom issue: Issue, formatter: DateFormatter) {
        
        var birthDateString = NSLocalizedString("Birth Date: ", comment: "Birth date field pefix")
        if let _date = issue.birthDate {
            birthDateString += formatter.string(from: _date)
        }
        else {
            birthDateString += "N/A"
        }
        
        text = birthDateString
    }
    
    func update(withCountFrom issue: Issue) {
        
        text = String(format: NSLocalizedString("Issues count: %ld", comment: "Issues cound display format"), issue.issueCount)
    }
}
