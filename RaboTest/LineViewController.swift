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
    
    var headers: [String]!
    
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
        
        var count = 0
        
        if headers != nil && !headers.isEmpty {
            count = headers.count
        }
        else if line != nil && !line.isEmpty {
            count = line.count
        }
        
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if line != nil, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseId, for: indexPath) as? ItemCell {
            
            var title: String = ""
            var value: Any = ""
            
            if headers != nil && indexPath.row < headers.count {
                title = headers[indexPath.row]
                value = line[title] ?? ""
            }
            else if line != nil && indexPath.row < line.count {
                title = Array(line.keys)[indexPath.item]
                value = line[title] ?? ""
            }
            
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
        
        var title: String = ""
        var count = 0
        
        if headers != nil && indexPath.row < headers.count {
            title = headers[indexPath.row]
            count = headers.count
        }
        else if line != nil && indexPath.row < line.count {
            title = Array(line.keys)[indexPath.item]
            count = line.count
        }
        
        let value = String.from(value: line[title] ?? ("" as Any))
        
        let font = UIFont.systemFont(ofSize: 17)
        let titleWidth = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: font]).boundingRect(with: CGSize(width: 10000, height: 100), options: .usesLineFragmentOrigin, context: nil).size.width
        let valueWidth = NSAttributedString(string: "\(value)", attributes: [NSAttributedString.Key.font: font]).boundingRect(with: CGSize(width: 10000, height: 100), options: .usesLineFragmentOrigin, context: nil).size.width

        width = max(titleWidth, valueWidth) + CGFloat(max(count - 1, 1) * 5)
        
        return CGSize(width: width, height: collectionView.bounds.size.height)
    }

}
