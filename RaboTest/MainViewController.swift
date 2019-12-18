//
//  MainViewController.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 16/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    // MARK: - Controller Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupUI()
        loadBundleData()
    }
    
    // MARK: - UI Customization
    
    private func setupUI() {
        
    }
    
    // MARK: - UI manipulations
    
    private func show(error: Error) {
        
        let alert = UIAlertController(title: NSLocalizedString("Error loading data", comment: "Error dialog title when data loading failed"), message: error.localizedDescription.nilIfEmpty ?? NSLocalizedString("Failed to load data", comment: "General error message when failed to load data"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK button title"), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Data integrations
    
    var file: CSVFile?
    
    private func loadBundleData() {
        
        if let path = Bundle.main.path(forResource: "issues", ofType: "csv"), let _file = CSVFile(localFileURL: URL(fileURLWithPath: path)) {
        
            file = _file
        }
    }
    
    private func updateTabs(text: String?) {

        if let _controllers = viewControllers {
            
            for controller in _controllers {
                
                if var _controller = controller as? ListViewController {

                }
            }
        }
    }
}
