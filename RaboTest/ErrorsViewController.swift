//
//  ErrorsViewController.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 18/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit

/// Displays errors that might have occured during loading and parsing CSV file
class ErrorsViewController: UIViewController, CSVDisplayController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var errorsTableView: UITableView!
    
    // MARK: - Controller Lifecycle
    
    /// Errors to display
    private var errors: [Error]? {
        didSet {
            if isViewLoaded {
                errorsTableView.reloadData()
                toggleTableViewFooter()                
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupViewIdentifiers()
        setupUI()
    }
    
    // MARK: - UI customization
    
    private func setupUI() {
        
        title = NSLocalizedString("Errors", comment: "Errors display title")
        
        toggleTableViewFooter()
    }
    
    private func toggleTableViewFooter() {

        if (errors?.count ?? 0) == 0 {
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: errorsTableView.bounds.size.width, height: 30.0))
            label.autoresizingMask = [.flexibleWidth]
            label.text = NSLocalizedString("No errors", comment: "Placeholder when no errors occured during reading")
            label.font = UIFont.systemFont(ofSize: 15)
            label.textAlignment = .center
            
            label.accessibilityIdentifier = "empty_placeholder.table.errors"
            
            errorsTableView.tableFooterView = label
        }
        else {
            
            errorsTableView.tableFooterView = UIView()
        }
    }

    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return errors?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let _errors = errors, indexPath.row < _errors.count, let cell = tableView.dequeueReusableCell(withIdentifier: ErrorCell.reuseId, for: indexPath) as? ErrorCell {
            
            let error = _errors[indexPath.row]
            cell.setup(error: error)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    // MARK: - CSVDisplayController
    
    weak var file: CSVFile?
    
    func add(lines: [CSVLine], index: Int) {
    }
    
    func readComplete(text: String?, errors: [Error]?) {
        
        self.errors = errors
    }
    
    // MARK: - UI Testing
    
    private func setupViewIdentifiers() {
        
        errorsTableView.accessibilityIdentifier = "table.errors"
    }
}
