//
//  TextViewController.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 18/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit

class TextViewController: UIViewController, CSVDisplayController {
    
    @IBOutlet weak var csvTextView: UITextView!
    
    private var text = NSLocalizedString("Loading CSV file please wait...", comment: "Placeholder when file being loaded")
    
    // MARK: - Controller Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        csvTextView.text = text
    }
    
    // MARK: - UI Customization
    
    private func setupUI() {
        
        title = NSLocalizedString("TXT", comment: "TXT display title")
    }

    // MARK: - CSVDisplayController
    
    weak var file: CSVFile?
    
    func add(line: [String : Any], index: Int) {
    }
    
    func readComplete(text: String?, errors: [Error]?) {
        
        self.text = text ?? NSLocalizedString("Empty file", comment: "Placeholder for empty file content")
        if isViewLoaded {
            csvTextView.text = self.text
        }
    }
}