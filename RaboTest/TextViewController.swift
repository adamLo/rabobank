//
//  TextViewController.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 18/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit

/// Displays loaded CSV as plain text so users can compare parsed content with original
class TextViewController: UIViewController, CSVDisplayController {
    
    @IBOutlet weak var csvTextView: UITextView!
    
    private var text = NSLocalizedString("Loading CSV file please wait...", comment: "Placeholder when file being loaded")
    
    // MARK: - Controller Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupViewIdentifiers()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        csvTextView.text = text
    }
    
    // MARK: - UI Customization
    
    private func setupUI() {
        
        title = NSLocalizedString("TXT", comment: "TXT display title")
        
        csvTextView.font = UIFont.systemFont(ofSize: 15)
    }

    // MARK: - CSVDisplayController
    
    weak var file: CSVFile?
    
    func add(lines: [CSVLine], index: Int) {
    }
    
    func readComplete(text: String?, errors: [Error]?) {
        
        guard isViewLoaded else {return}
        
        self.text = text ?? NSLocalizedString("Empty file", comment: "Placeholder for empty file content")
        if isViewLoaded {
            csvTextView.text = self.text
        }
    }
    
    // MARK: - UI Testing
    
    private func setupViewIdentifiers() {
        
        csvTextView.accessibilityIdentifier = "text.txt"
    }
}
