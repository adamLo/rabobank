//
//  CSVProcessor.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 16/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation

typealias ProcessCompleteBlock = ((_ textResult: String?, _ issues: [Issue]?, _ error: Error?) -> ())

/// Service class that can be initialized with an url to a CSV file in the bundle
class CSVProcessor {
    
    /// URL to file in the bundle
    private let fileURL: URL
    
    /// Contains processed results
    private(set) var issues: [Issue]?
    
    private let errorDomain = "CSVPROCESSOR"
    
    /// Initialize with an URL to a local file in the bundle
    init?(localFileURL: URL) {
        
        guard FileManager.default.fileExists(atPath: localFileURL.path) else {return nil}
        
        self.fileURL = localFileURL
    }
    
    func load() -> (contents: String?, error: Error?) {
        
        do {
            let contents = try String(contentsOf: fileURL)
            return (contents.nilIfEmpty, nil)
        }
        catch let error {
            return (nil, error)
        }
    }
    
    func process(text: String, skipFirstLine: Bool) -> (issues: [Issue]?, error: Error?) {
        
        let lines = text.replacingOccurrences(of: "\r", with: "").split(separator: "\n")
        
        guard lines.count > (skipFirstLine ? 1 : 0) else {return (nil, createError(code: -1, message: NSLocalizedString("Empty file", comment: "Error when processed and empty file")))}
        
        var issues = [Issue]()
        
        // Line 0 contains header
        for index in (skipFirstLine ? 1 : 0)..<lines.count {
            
            if let line = String(lines[index]).nilIfEmpty, let issue = Issue(text: line) {
                issues.append(issue)
            }
            else {
                let error = createError(code: -2, message: String(format: NSLocalizedString("Error in line %ld", comment: "Error message format when processing a text file failed due parsing a line"), index))
                return (nil, error)
            }
        }

        return (issues, nil)
    }
    
    /// Load and Process file
    /// progress: block called when progress made
    /// completion: block called when completed, params: textresult is nil if successfully processed otherwise loaded file, issues if processed, error if occured
    func loadAndProcess(completion: ProcessCompleteBlock?) {
        
        issues = nil
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let (lines, loadError) = self.load()
            
            guard let _lines = lines else {
                DispatchQueue.main.async {
                    let _error = loadError ?? self.createError(code: -3, message: NSLocalizedString("Error loading CSV file", comment: "General error when loading a csv file for processing"))
                    completion?(nil, nil, _error)
                }
                return
            }
            
            let (_issues, processError) = self.process(text: _lines, skipFirstLine: true)
            
            DispatchQueue.main.async {

                self.issues = _issues
                completion?(_issues != nil ? nil : _lines, _issues, processError)
            }
        }
    }
    
    private func createError(code: Int, message: String) -> NSError {
        
        return NSError(domain: self.errorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
