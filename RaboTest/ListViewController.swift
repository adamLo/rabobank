//
//  ListViewController.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 16/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit

/// Controller to display loaded issues in a list view
class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CSVDisplayController {

    @IBOutlet weak var listTableView: UITableView!
    
    // MARK: - Controller Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
    }

    // MARK: - UI Customization
    
    private func setupUI() {
        
        listTableView.tableFooterView = UIView()
    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return file?.lines.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let lines = file?.lines, lines.count > indexPath.row, let cell = tableView.dequeueReusableCell(withIdentifier: ListLineCell.reuseId, for: indexPath) as? ListLineCell {
            
            let line = lines[indexPath.row]
            cell.setup(values: line)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: - CSVDisplayController
    
    weak var file: CSVFile?
    
    func add(line: [String : Any], index: Int) {
        
//        listTableView.beginUpdates()
//        listTableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .none)
//        listTableView.endUpdates()
        listTableView.reloadData()
    }
    
    func readComplete(errors: [Error]?) {
        
        listTableView.reloadData()
    }
}
