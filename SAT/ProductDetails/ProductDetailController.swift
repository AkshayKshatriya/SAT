//
//  ProductDetailController.swift
//  SAT
//
//  Created by akshay on 16/07/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import Foundation
import UIKit
import DropDown
import DynamicJSON

class ProductDetailController: UIViewController {
    
    @IBOutlet var colorViews: [UIView]!
    @IBOutlet weak var dropView: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    let dropDown = DropDown()
    var productObj : JSON?
    var productDetailViewModel : ProductDetailViewModel?

    override func viewDidLoad() {
        imageView.backgroundColor = UIColor.random()
        self.productDetailViewModel = ProductDetailViewModel.init(productObj: productObj!, controller: self)
    }
    
    override func viewDidLayoutSubviews() {
        self.dropDown.anchorView = dropView // UIView or UIBarButtonItem
    }
    
    @IBAction func dropViewTap(_ sender: Any) {
        self.dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.dropView.text = "\(item) ▼"
            let varients =  (self.productObj!.variants.array)!
            let selectedVarients = varients.filter({ (varient) -> Bool in
                return varient.size.int == Int(item)
            })
            let colorArray = selectedVarients.map{ $0.color.string! }
            print(colorArray)
            self.productDetailViewModel?.colorArray = colorArray
        }
    }
}
