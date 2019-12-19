//
//  CSVFile.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 17/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import Foundation

typealias CSVLine = [String: Any]
typealias LinesReadBlock = ((_ index: Int?, _ lines: [CSVLine]?) -> ())
typealias CompletionBlock = ((_ text: String?, _ errors: [Error]?) -> ())

/// CSV file loader and parser
class CSVFile {
    
    /// Contains field names
    private var _fieldNames = [String]()
    var fieldNames: [String] {
        linesReadQueue.sync {
            return self._fieldNames
        }
    }
    
    /// Contains loaded lines
    private var _lines = [CSVLine]()
    var lines: [CSVLine] {
        get {
            linesReadQueue.sync {
                return self._lines
            }
        }
    }
    // Queue to handle threading
    private let linesReadQueue = DispatchQueue(label: "LinesReadQueue")
        
    /// URL to file in the bundle
    private let fileURL: URL
    
    /// Maximum number of characters to load at a time
    private let maxReadLength = 512
    
    /// Date formatter to parse date strings
    static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    
    /// Error domain, used when creating errors
    private let errorDomain = "CSVFILE"
    
    /// Indicates wheter loading and parsing is in progress
    private(set) var isLoading = false
    
    /// Initialize with an URL to a local file in the bundle
    init?(localFileURL: URL) {
        
        guard FileManager.default.fileExists(atPath: localFileURL.path) else {return nil}
        
        self.fileURL = localFileURL
    }
    
    /// Loads csv file and calls linesRead after each line loaded and parsed and completion when finished
    func load(firstLineAsHeader: Bool, linesRead: LinesReadBlock?, completion: CompletionBlock?) {
        
        guard !isLoading else {
            DispatchQueue.main.async {
                completion?(nil, [self.createError(code: -2, message: NSLocalizedString("Loading already in progress", comment: "Error message when invoced load() while loading in progress"))])
            }
            return
        }
        
        isLoading = true
        
        linesReadQueue.sync {
            _lines.removeAll()
        }
        
        DispatchQueue.global(qos: .default).async {
            
            guard let stream = InputStream(fileAtPath: self.fileURL.path) else {
                DispatchQueue.main.async {
                    completion?(nil, [self.createError(code: -1, message: NSLocalizedString("Error opening file", comment: "Error message when failed to open file"))])
                }
                return
            }
                    
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: self.maxReadLength)
            var text = ""
            
            var leftOver = ""
            
            var lineIndex = 0
            
            var errors = [Error]()
            
            stream.open()
        
            while stream.hasBytesAvailable {
                
                let numberOfBytesRead = stream.read(buffer, maxLength: self.maxReadLength)
                if numberOfBytesRead < 0, let error = stream.streamError {
                    errors.append(error)
                }
                else if numberOfBytesRead > 0 {
                    
                    if let textRead = String(bytesNoCopy: buffer, length: numberOfBytesRead, encoding: .utf8, freeWhenDone: false) {
                        
                        text.append(textRead)
                        leftOver = self.process(textRead: textRead, leftOver: leftOver, final: false, asHeader: firstLineAsHeader, lineIndex: &lineIndex, linesRead: linesRead)
                    }
                }
            }
            
            stream.close()
            
            if let _leftover = leftOver.nilIfEmpty {
                self.process(textRead: "", leftOver: _leftover, final: true, asHeader: firstLineAsHeader, lineIndex: &lineIndex, linesRead: linesRead)
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
                completion?(text, errors.isEmpty ? nil : errors)
            }
        }
    }
    
    /// Processes a chunk of content read from stream. textRead: read block, leftOver: leftover text from previous read. final: indicates whether a NL should be expected at the end. asHeader: indicates whether first line should be treated as header. lineIndex: current read and parsed line index. linesRead: block executed when a batch of lines parsed. Returns leftover text after processing
    @discardableResult
    func process(textRead: String, leftOver: String, final: Bool, asHeader: Bool, lineIndex: inout Int, linesRead: LinesReadBlock?) -> String {
        
        let (_lines, _leftover) = self.process(text: "\(leftOver)\(textRead)", final: final)
        if !_lines.isEmpty {
            
            var processedLines = [CSVLine]()
            
            for line in _lines {
                let strings = self.process(line: line)
                if lineIndex == 0 && asHeader {
                    self.linesReadQueue.async {
                        self._fieldNames = strings
                    }
                }
                else {
                    let values = self.process(strings: strings, fieldNames: self.fieldNames)
                    
                    self.linesReadQueue.async {
                        self._lines.append(values)
                    }
                    
                    processedLines.append(values)
                }
                
                lineIndex += 1
            }
            
            let index = lineIndex
            DispatchQueue.main.async {
                linesRead?(max(index - 1, 0), processedLines)
            }
        }
        
        return _leftover
    }
    
    /// Processes a piece of read text into array of lines and returns leftover (if not final)
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
    
    /// Processes a single line of read text into array of strings to parse
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
    
    /// Processes array of strings read from a line into parsed values. strings: array of string values. fieldNames: determines associative index
    func process(strings: [String], fieldNames: [String]) -> CSVLine {
        
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
    
    /// Parses a string into a typed value
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
    
    /// Date formatter used to parse a date string
    private lazy var dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateFormat = CSVFile.dateFormat
        return formatter
    }()
    
    /// Constructs an error from code and message
    private func createError(code: Int, message: String) -> NSError {
        
        return NSError(domain: self.errorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
