//
//  ErrorsViewController.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 18/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit

class ErrorsViewController: UIViewController, CSVDisplayController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var errorsTableView: UITableView!
    
    // MARK: - Controller Lifecycle
    
    private var errors: [Error]? {
        didSet {
            if isViewLoaded {
                errorsTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - UI customization
    
    private func setupUI() {
        
        title = NSLocalizedString("Errors", comment: "Errors display title")
        
        errorsTableView.tableFooterView = UIView()
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
    
    // MARK: - CSVDisplayController
    
    weak var file: CSVFile?
    
    func add(line: [String : Any], index: Int) {
    }
    
    func readComplete(text: String?, errors: [Error]?) {
        
        self.errors = errors
    }
}
