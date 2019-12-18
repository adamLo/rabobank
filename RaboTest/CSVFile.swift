//
//  CSVFile.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 17/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation

typealias LineReadBlock = ((_ line: [String: Any]?) -> ())
typealias CompletionBlock = ((_ errors: [Error]?) -> ())

class CSVFile {
    
    /// Contains field names
    private(set) var fieldNames = [String]()
    /// Contains loaded lines
    private(set) var lines = [[String: Any]]()
    
    /// URL to file in the bundle
    private let fileURL: URL
    
    /// Maximum number of characters to load at a time
    private let maxReadLength = 256
    
    /// Date formatter to parse date strings
    private let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    
    private let errorDomain = "CSVFILE"
    
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
                    completion?([self.createError(code: -1, message: NSLocalizedString("Error opening file", comment: "Error message when failed to open file"))])
                }
                return
            }
                    
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: self.maxReadLength)
            var text = ""
            
            var leftOver = ""
            
            var lineIndex = 0
            
            var errors = [Error]()
            
            stream.open()
        
            while stream.hasBytesAvailable && !self.stopReading {
                
                let numberOfBytesRead = stream.read(buffer, maxLength: self.maxReadLength)
                if numberOfBytesRead < 0, let error = stream.streamError {
                    errors.append(error)
                }
                else if numberOfBytesRead > 0 {
                    
                    if let textRead = String(bytesNoCopy: buffer, length: numberOfBytesRead, encoding: .utf8, freeWhenDone: true) {
                        
                        text.append(textRead)
                        leftOver = self.process(textRead: textRead, leftOver: leftOver, final: false, lineIndex: &lineIndex, lineRead: lineRead)
                    }
                }
            }
            
            stream.close()
            
            if let _leftover = leftOver.nilIfEmpty {
                self.process(textRead: "", leftOver: _leftover, final: true, lineIndex: &lineIndex, lineRead: lineRead)
            }
            
            DispatchQueue.main.async {
                completion?(errors.isEmpty ? nil : errors)
            }
        }
    }
    
    func stopLoading() {
        stopReading = true
    }
    
    @discardableResult
    func process(textRead: String, leftOver: String, final: Bool, lineIndex: inout Int, lineRead: LineReadBlock?) -> String {
        
        let (_lines, _leftover) = self.process(text: "\(leftOver)\(textRead)", final: final)
        if !_lines.isEmpty {
            for line in _lines {
                let strings = self.process(line: line)
                if lineIndex == 0 {
                    self.fieldNames = strings
                }
                else {
                    let values = self.process(strings: strings, fieldNames: self.fieldNames)
                    self.lines.append(values)
                    
                    DispatchQueue.main.async {
                        lineRead?(values)
                    }
                }
                
                lineIndex += 1
            }
        }
        
        return _leftover
    }
    
    func process(text: String, final: Bool) -> (lines: [String], leftOver: String) {
        
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
        
        if nsText.length > 0, final {
            lines.append(String(nsText))
            nsText.deleteCharacters(in: NSMakeRange(0, nsText.length))
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
    
    func process(strings: [String], fieldNames: [String]) -> [String: Any] {
        
        var result = [String: Any]()
        
        for index in 0..<strings.count {
            
            var fieldName = String(index)
            if index < fieldNames.count, let _name = fieldNames[index].nilIfEmpty {
                fieldName = _name
            }
            
            let stringValue = strings[index]
            let _value = value(of: stringValue)
            
            result[fieldName] = _value
        }
        
        return result
    }
    
    func value(of string: String) -> Any {
        
        if let value = Int(string) {
            return value
        }
        else if let value = Double(string) {
            return value
        }
        else if let value = Bool(string) {
            return value
        }
        else if let value = dateFormatter.date(from: string) {
            return value
        }
        
        return string
    }
    
    private lazy var dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter
    }()
    
    private func createError(code: Int, message: String) -> NSError {
        
        return NSError(domain: self.errorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
