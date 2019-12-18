//
//  ListLineCell.swift
//  RaboTest
//
//  Created by Adam Lovastyik on 18/12/2019.
//  Copyright © 2019 Adam Lovastyik. All rights reserved.
//

import UIKit

class ListLineCell: UITableViewCell {
    
    static let reuseId = "lineCell"

    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var holderHeight: NSLayoutConstraint!
    @IBOutlet weak var holderWidth: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    func setup(values: [String: Any]) {
        
        var lastX: CGFloat = 0
        var maxHeight: CGFloat = 0
        
        for (key, value) in values {
            
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            titleLabel.text = key
            titleLabel.sizeToFit()
            
            let valueLabel = UILabel(frame: CGRect(x: titleLabel.frame.origin.x, y: titleLabel.frame.origin.y + titleLabel.frame.size.height, width: 0, height: 0))
            valueLabel.text = "\(value)"
            valueLabel.sizeToFit()
            
            let holder = UIView(frame: CGRect(x: lastX, y: 0, width: max(titleLabel.frame.origin.x, valueLabel.frame.origin.x) + max(titleLabel.frame.size.width, valueLabel.frame.size.width), height: max(titleLabel.frame.origin.y + titleLabel.frame.size.height, valueLabel.frame.origin.y + valueLabel.frame.size.height)))
            holder.backgroundColor = UIColor.clear
            holder.addSubview(titleLabel)
            holder.addSubview(valueLabel)
            
            lastX += holder.frame.origin.x + holder.frame.size.width
            
            holderView.addSubview(holder)
            
            maxHeight = max(maxHeight, holder.frame.size.height)
        }
        
        scrollView.contentSize = CGSize(width: lastX, height: maxHeight)
        
        holderWidth.constant = lastX
        holderHeight.constant = maxHeight
        scrollHeight.constant = maxHeight
        contentView.layoutIfNeeded()
    }

    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        for view in holderView.subviews {
            view.removeFromSuperview()
        }
    }

}
