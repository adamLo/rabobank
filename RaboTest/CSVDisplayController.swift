//
//  CSVDisplayController.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 18/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation

/// Protocol implemented by all view controllers that display any part of loaded file
protocol CSVDisplayController {
    
    /// File loader instance
    var file: CSVFile? {get set}
    
    /// Adds a parsed line to display. Lines: array of maps of parsed content. Index: last read line index
    func add(lines: [CSVLine], index: Int)
    
    /// Called when loading and parsing completed. text: plain text read from file. errors: array of errors occured durin reading file
    func readComplete(text: String?, errors: [Error]?)
}
