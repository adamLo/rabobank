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
}
