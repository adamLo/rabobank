//
//  CSVProcessor.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 16/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation

typealias ProcessUpdateBlock = ((_ progress: Float) -> ())
typealias ProcessCompleteBlock = ((_ textResult: String?, _ issues: [Issue]?, _ error: Error?) -> ())

/// Service class that can be initialized with an url to a CSV file in the bundle
class CSVProcessor {
    
    /// URL to file in the bundle
    private let fileURL: URL
    
    /// Contains processed results
    private(set) var issues: [Issue]?
    
    /// Initialize with an URL to a local file in the bundle
    init?(localFileURL: URL) {
        
        guard FileManager.default.fileExists(atPath: localFileURL.path) else {return nil}
        
        self.fileURL = localFileURL
    }
    
    func load() -> (contents: String?, error: Error?) {
        
        do {
            let contents = try String(contentsOf: fileURL)
            return (contents, nil)
        }
        catch let error {
            return (nil, error)
        }
    }
    
    func process(text: String) -> (issues: [Issue]?, error: Error?) {
        
        let lines = text.split(separator: "\n")
        
        var issues = [Issue]()
        
        for index in 0..<lines.count {
            
            if let line = String(lines[index]).nilIfEmpty, let issue = Issue(text: line) {
                issues.append(issue)
            }
            else {
                let error = NSError(domain: "CSVProcessor", code: -1, userInfo: [NSLocalizedDescriptionKey: String(format: NSLocalizedString("Error in line %ld", comment: "Error message format when processing a text file failed due parsing a line"), index)])
                return (nil, error)
            }
        }
        
        let error = issues.isEmpty ? NSError(domain: "CSVProcessor", code: -2, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Empty file", comment: "Error when processed and empty file")]) : nil
        return (issues.isEmpty ? nil : issues, error)
    }
    
    /// Load and Process file
    /// progress: block called when progress made
    /// completion: block called when completed, params: error and processed content
    func loadAndProcess(progress: ProcessUpdateBlock?, completion: ProcessUpdateBlock?) {
        
    }
}
