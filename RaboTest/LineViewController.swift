//
//  LineViewController.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 18/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit

class LineViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    @IBOutlet weak var lineCollectionView: UICollectionView!
    
    var line: CSVLine! {
        didSet {
            if isViewLoaded {
                lineCollectionView.reloadData()
            }
        }
    }
    
    class func controller() -> LineViewController {
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LineViewController") as! LineViewController
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - CollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return line != nil ? line.count : 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if line != nil, line.count > indexPath.item, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseId, for: indexPath) as? ItemCell {
            
            let title = Array(line.keys)[indexPath.item]
            let value = line[title]
            
            cell.setup(title: title, value: value)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width: CGFloat = 50
        
        if line != nil, line.count > indexPath.item {
            
            let title = Array(line.keys)[indexPath.item]
            let value = line[title]
            
            let font = UIFont.systemFont(ofSize: 17)
            let titleWidth = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: font]).boundingRect(with: CGSize(width: 10000, height: 100), options: .usesLineFragmentOrigin, context: nil).size.width
            var valueWidth: CGFloat = 0
            if let _value = value {
                valueWidth = NSAttributedString(string: "\(_value)", attributes: [NSAttributedString.Key.font: font]).boundingRect(with: CGSize(width: 10000, height: 100), options: .usesLineFragmentOrigin, context: nil).size.width
            }
            width = max(titleWidth, valueWidth)
        }
        
        return CGSize(width: width, height: collectionView.bounds.size.height)
    }

}
