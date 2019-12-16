//
//  GridViewController.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 16/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit

/// Controller to display issues in a grid
class GridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, IssuesDisplayController {
    
    @IBOutlet weak var gridCollectionView: UICollectionView!
    
    var issues: [Issue]? {
        didSet {
            if isViewLoaded {
                gridCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - controller LifeCycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    // MARK: - UI customization
    
    // MARK: - CollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return issues?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let _issues = issues, _issues.count > indexPath.item, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IssueGridCell.reuseId, for: indexPath) as? IssueGridCell {
            
            let issue = _issues[indexPath.item]
            cell.setup(with: issue)
            return cell
        }
        
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 120, height: 90)
    }
}
