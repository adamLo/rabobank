//
//  CSVDisplayController.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 18/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation

protocol CSVDisplayController {
    
    var file: CSVFile? {get set}
    
    func add(lines: [CSVLine], index: Int)
    func readComplete(text: String?, errors: [Error]?)
}
