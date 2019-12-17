//
//  CSVFile.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 17/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation

typealias LineReadBlock = ((_ line: [String: Any]?, _ error: Error?) -> ())
typealias CompletionBlock = (() -> ())

class CSVFile {
    
    /// Contains field names
    private(set) var fieldNames = [String]()
    /// Contains loaded lines
    private(set) var lines = [[String: Any]]()
    
    /// URL to file in the bundle
    private let fileURL: URL
    
    /// MAximum number of characters to load at a time
    private let maxReadLength = 256
    
    /// Initialize with an URL to a local file in the bundle
    init?(localFileURL: URL) {
        
        guard FileManager.default.fileExists(atPath: localFileURL.path) else {return nil}
        
        self.fileURL = localFileURL
    }
    
    private var stopReading = false
        
    func load(lineRead: LineReadBlock?, completion: CompletionBlock?) {
        
        stopReading = false
        lines.removeAll()
        
        DispatchQueue.global(qos: .default).async {
            
            guard let stream = InputStream(fileAtPath: self.fileURL.path) else {
                DispatchQueue.main.async {
                    completion?()
                }
                return
            }
                    
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: self.maxReadLength)
            var text = ""
            
            var leftOver = ""
            
            var lineIndex = 0
            
            stream.open()
        
            while stream.hasBytesAvailable && !self.stopReading {
                
                let numberOfBytesRead = stream.read(buffer, maxLength: self.maxReadLength)
                if numberOfBytesRead < 0, let error = stream.streamError {
                  print(error)
                }
                else if numberOfBytesRead > 0 {
                    
                    if let textRead = String(bytesNoCopy: buffer, length: numberOfBytesRead, encoding: .utf8, freeWhenDone: true) {
                        
                        text.append(textRead)
                        
                        let (_lines, _leftover) = self.process(text: textRead)
                        if !_lines.isEmpty {
                            for line in _lines {
                                let values = self.process(line: line)
                                if lineIndex == 0 {
                                    self.fieldNames = values
                                }
                                
                                lineIndex += 1
                            }
                        }
                        leftOver = _leftover
                    }
                }
            }
            
            if let _leftover = leftOver.nilIfEmpty {
                
            }
            
            stream.close()
            
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
    
    func stopLoading() {
        stopReading = true
    }
    
    func process(text: String) -> (lines: [String], leftOver: String) {
        
        let nsText = NSMutableString(string: text)
        var lines = [String]()
        
        var range = nsText.range(of: "\n")
        while range.location != NSNotFound {
            
            if let line = nsText.substring(to: range.location).nilIfEmpty {
                lines.append(line)
            }
            
            nsText.deleteCharacters(in: NSMakeRange(0, range.location + 1))
            
            range = nsText.range(of: "\n")
        }
        
        return (lines, String(nsText))
    }
    
    func process(line: String) -> [String] {
        
        var lines = [String]()
        let split = line.split(separator: ",")
        
        for text in split {
            
            if let trimmed = String(text).nilIfEmpty, let _text = trimmed.withoutQuotes.nilIfEmpty {
                lines.append(_text)
            }
            else {
                lines.append("")
            }
        }
        
        return lines
    }
}
