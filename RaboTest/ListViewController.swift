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
        
        title = NSLocalizedString("CSV", comment: "CSV display title")
        
        listTableView.tableFooterView = UIView()
    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return max(min(file?.lines.count ?? 0, lastIndex), 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let lines = file?.lines, lines.count >= lastIndex, lastIndex >= indexPath.row, let cell = tableView.dequeueReusableCell(withIdentifier: ListLineCell.reuseId, for: indexPath) as? ListLineCell {
            
            let headers: [String] = file?.fieldNames ?? []
            
            let line = lines[indexPath.row]
            cell.setup(values: line, headers: headers)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44.0//UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let _cell = cell as? ListLineCell, _cell.lineController != nil, !children.contains(_cell.lineController) {
            addChild(_cell.lineController)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let _cell = cell as? ListLineCell, _cell.lineController != nil, children.contains(_cell.lineController) {
            _cell.lineController.removeFromParent()
        }
    }
    
    // MARK: - CSVDisplayController
        
    private var lastIndex = -1
    
    weak var file: CSVFile?
    
    func add(lines: [CSVLine], index: Int) {
        
        let previousIndex = lastIndex
        lastIndex = index
        
        if previousIndex >= 0, index > previousIndex {

            var indexPaths = [IndexPath]()
            for newIndex in previousIndex..<index {
                indexPaths.append(IndexPath(row: newIndex, section: 0))
            }
            
            listTableView.beginUpdates()
            listTableView.insertRows(at: indexPaths, with: .none)
            listTableView.endUpdates()
        }
        else {
            listTableView.reloadData()
        }
    }
    
    func readComplete(text: String?, errors: [Error]?) {
        
        lastIndex = max(lastIndex, (file?.lines.count ?? 0) - 1)
        listTableView.reloadData()
    }
}
