//
//  Issue.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 16/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation

struct Issue {
    
    let firstName: String?
    let surName: String?
    let issueCount: Int
    let birthDate: Date?
    
    private struct dataFormat {
        static let firstNameIndex   = 0
        static let surNameIndex     = 1
        static let issueCountIndex  = 2
        static let dobIndex         = 3
        static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        static let minimumFieldCount = 4
    }
    
    /// Initializes an issue with string read from csv file in format: "First name","Sur name","Issue count","Date of birth". Fails to init if fewer than required fields
    init?(text: String) {
        
        let components = text.split(separator: ",")
        
        guard components.count >= dataFormat.minimumFieldCount else {return nil}
        
        firstName = String(components[dataFormat.firstNameIndex]).trimmed.withoutQuotes.nilIfEmpty
        surName = String(components[dataFormat.surNameIndex]).trimmed.withoutQuotes.nilIfEmpty

        if let issueCountText = String(components[dataFormat.issueCountIndex]).trimmed.withoutQuotes.nilIfEmpty, let _issueCount = Int(issueCountText) {
            issueCount = _issueCount
        }
        else {
            issueCount = 0
        }
        
        if let dobText = String(components[dataFormat.dobIndex]).trimmed.withoutQuotes.nilIfEmpty {
            let formatter = DateFormatter()
            formatter.dateFormat = dataFormat.dateFormat
            birthDate = formatter.date(from: dobText)
        }
        else {
            birthDate = nil
        }
    }
}
