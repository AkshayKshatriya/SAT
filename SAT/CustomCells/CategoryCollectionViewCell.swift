//
//  CategoryCollectionViewCell.swift
//  Mutterfly
//
//  Created by Akshay Gawade on 10/04/17.
//  Copyright © 2017 Mutterfly. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var selectedView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
