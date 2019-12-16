//
//  ListViewController.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 16/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit

/// Controller to display loaded issues in a list view
class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, IssuesDisplayController {

    @IBOutlet weak var listTableView: UITableView!
    
    var issues: [Issue]? {
        didSet {
            if isViewLoaded {
                listTableView.reloadData()
            }
        }
    }
    
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
        
        return issues?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let _issues = issues, _issues.count > indexPath.row, let cell = tableView.dequeueReusableCell(withIdentifier: IssueListCell.reuseId, for: indexPath) as? IssueListCell {
            
            let issue = _issues[indexPath.row]
            cell.setup(with: issue)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 85.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
