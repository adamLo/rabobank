//
//  StringUtil.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 16/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation

/// Utilities to manipulate strings
extension String {
    
    /// Returns string trimmed off white spaces and new lines
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Returns trimmed or nil if trimmed is empty
    var nilIfEmpty: String? {
        let _trimmed = self.trimmed
        return _trimmed.isEmpty ? nil : _trimmed
    }
    
    /// Returns string without starting and ending quotes
    var withoutQuotes: String {
        
        var nsValue = NSString(string: self)
        
        if nsValue.substring(to: 1) == "\"" {
            nsValue = NSString(string: nsValue.substring(from: 1))
        }
        
        if nsValue.length >= 1, nsValue.substring(from: nsValue.length - 1) == "\"" {
            nsValue = NSString(string: nsValue.substring(to: nsValue.length - 1))
        }
        
        return String(nsValue)
    }
    
    static func from(value: Any) -> String {
        
        if let intValue = value as? Int {
            return String(intValue)
        }
        else if let doubleValue = value as? Double {
            return String(doubleValue)
        }
        else if let boolValue = value as? Bool {
            return boolValue ? NSLocalizedString("True", comment: "True boolean value") : NSLocalizedString("False", comment: "False boolean value")
        }
        else if let dateValue = value as? Date {
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            
            let components = Calendar.current.dateComponents([.hour, .minute, .second], from: dateValue)
            formatter.timeStyle = (components.hour ?? 0) > 0 && (components.minute ?? 0) > 0 && (components.second ?? 0) > 0 ? .short : .none
            
            return formatter.string(from: dateValue)
        }
        else {
            return "\(value)"
        }
    }
}
