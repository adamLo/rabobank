//
//  MainViewController.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 16/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit

/// Main viewcontroller that encapsulates 3 tabs to show parsed file, original plain text and errors
class MainViewController: UITabBarController {
    
    // MARK: - Controller Lifecycle
        
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
        setupViewIdentifiers()
        
        load(fileName: (UIApplication.shared.delegate as? AppDelegate)?.fileToRead.nilIfEmpty ?? "NO_FILE_PROVIDED")
    }
    
    // MARK: - UI Customization
    
    private func setupUI() {
     
        title = NSLocalizedString("CSV Reader", comment: "Main screen title")
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        
        if let items = tabBar.items {
            
            for index in 0..<items.count {
                
                let item = items[index]
                switch index {
                case 0:
                    item.image = UIImage(named: "tab-icon-csv")
                    item.title = NSLocalizedString("CSV", comment: "CSV display title")
                case 1:
                    item.image = UIImage(named: "tab-icon-txt")
                    item.title = NSLocalizedString("TXT", comment: "TXT display title")
                case 2:
                    item.image = UIImage(named: "tab-icon-errors")
                    item.title = NSLocalizedString("Errors", comment: "Errors display title")
                default: break
                }
            }
        }
    }
    
    // MARK: - UI manipulations
    
    /// Toggles UI to show if loading in progress
    private func toggleActivity(_ loading: Bool) {
        
        if loading && navigationItem.rightBarButtonItem == nil {
            
            let activiy = UIActivityIndicatorView(style: .medium)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activiy)
            activiy.startAnimating()
            
            title = NSLocalizedString("Loading file...", comment: "Loading title on indicator view")
        }
        else if !loading, let activity = navigationItem.rightBarButtonItem?.customView as? UIActivityIndicatorView {
            
            activity.stopAnimating()
            navigationItem.rightBarButtonItem = nil
            
            title = NSLocalizedString("CSV Reader", comment: "Main screen title")
        }
    }
    
    // MARK: - Data integrations
    
    /// CSV File loader and parser instance
    private var file: CSVFile?
    
    /// Loads file with given name
    private func load(fileName: String) {
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "csv"), let _file = CSVFile(localFileURL: URL(fileURLWithPath: path)) {
        
            file = _file
            updateTabs(file: _file)
            
            toggleActivity(true)
            
            updateTabs(text: nil, errors: nil)
            
            _file.load(firstLineAsHeader: true, linesRead: {[weak self] (index, lines) in
                
                if let _self = self, let _index = index, let _lines = lines {
                    _self.updateTabs(index: _index, lines: _lines)
                }
            }) {[weak self] (text, errors) in
                
                self?.updateTabs(text: text, errors: errors)
                self?.toggleActivity(false)
            }
        }
        else {
            updateTabs(text: nil, errors: [NSError(domain: CSVFile.errorDomain, code: -3, userInfo: [NSLocalizedDescriptionKey: String(format: NSLocalizedString("File not found: %@", comment: "Error message format for file not found error"), "\(fileName).csv")])])
        }
    }
        
    private func updateTabs(file: CSVFile) {

        if let _controllers = viewControllers {
            for controller in _controllers {
                
                if var _controller = controller as? CSVDisplayController {
                    _controller.file = file
                }
            }
        }
    }
    
    private func updateTabs(index: Int, lines: [CSVLine]) {
        
        if let _controllers = viewControllers {
            for controller in _controllers {
                
                if let _controller = controller as? CSVDisplayController {
                    _controller.add(lines: lines, index: index)
                }
            }
        }
    }
    
    private func updateTabs(text: String?, errors: [Error]?) {
        
        if let _controllers = viewControllers {
            for controller in _controllers {
                
                if let _controller = controller as? CSVDisplayController {
                    _controller.readComplete(text: text, errors: errors)
                }
            }
        }
        
        if tabBar.items?.count ?? 0 > 1 {
            tabBar.items?[2].badgeValue = (errors?.isEmpty ?? true) ? nil : "!"
        }
    }
    
    // MARK: - UI Testing
    
    private func setupViewIdentifiers() {
        
        tabBar.accessibilityIdentifier = "tabbar.main"
        
        if let items = tabBar.items {
            for index in 0..<items.count {
                let item = items[index]
                switch index {
                case 0:
                    item.accessibilityIdentifier = "csv.tab.main"
                case 1:
                    item.accessibilityIdentifier = "txt.tab.main"
                case 2:
                    item.accessibilityIdentifier = "errors.tab.main"
                default: break
                }
            }
        }
        
        navigationController?.navigationBar.accessibilityIdentifier = "navbar.main"
    }
}
