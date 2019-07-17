//
//  BrowseProductController.swift
//  SAT
//
//  Created by Akshay Gawade on 15/07/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import Foundation
import UIKit
import DynamicJSON


class BrowseProductController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var productsArray : [JSON]?
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    //horizontal space between cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //vertical space between cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellSize = CGSize.init(width: (self.view.frame.width * 0.498), height: (self.view.frame.width * 0.68
            
        ))
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if productsArray != nil && productsArray!.count > 0 {
            return productsArray!.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as? ProductCollectionCell
        let productModel = productsArray![indexPath.row]
        productCell?.Name.text = productModel.name.string
        if let variants = productModel.variants.array, variants.count > 0
        {
            productCell?.Price.text = "₹ \(variants[0].price.int!)"
            if let size = variants[0].size.int
            {
                productCell?.size.text = "Size: \(size)"
            }
        }
        return productCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productModel = productsArray![indexPath.row]
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let productDetailController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailController") as? ProductDetailController
        productDetailController?.productObj = productModel
        self.navigationController?.pushViewController(productDetailController!, animated: true)

    }
    
    override func viewDidLoad() {
        productsCollectionView!.register(UINib.init(nibName: "ProductCollectionCell", bundle: nil), forCellWithReuseIdentifier: "productCell")
        productsCollectionView!.backgroundColor = UIColor.clear
        productsCollectionView!.dataSource = self
        productsCollectionView!.delegate = self
        productsCollectionView.backgroundColor = UIColor.groupTableViewBackground
        productsCollectionView!.showsHorizontalScrollIndicator = false
        productsCollectionView!.showsVerticalScrollIndicator = false
        productsCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
}
