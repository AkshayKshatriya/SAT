//
//  ViewController.swift
//  SAT
//
//  Created by Akshay Gawade on 11/07/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import UIKit
import DynamicJSON
import NVActivityIndicatorView

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}










class ViewController: UIViewController {
    struct RankingModel {
        var name = ""
        var id = 0
        var count = 0
    }
    struct SubCategories {
        var category : JSON?
        var parent : Int?
    }
    
    @IBOutlet weak var loader: NVActivityIndicatorView!
    @IBOutlet weak var subcategoryCollectionView: UICollectionView!
    @IBOutlet weak var categoryTable: UITableView!
    var result : JSON?
    var sectionArray = [JSON]()
    var cellArray = [SubCategories]()
    var nodeArray = [JSON]()
    var rootArray = [JSON]()
    var expandArray = [Int]()
    var selectedCategory = 0
    var productsArray = [JSON]()
    var mostViewedArray = [RankingModel]()
    var mostOrderedArray = [RankingModel]()
    var mostSharedArray = [RankingModel]()
    var cellType : Any?
    
    enum SortType {
        case Viewed
        case Ordered
        case Shared
        case Unsorted
    }
    
    func sortByOrder() {
        for rankingObj in self.result!.rankings.array![1].products.array! {
            for product in productsArray
            {
                if product.id.int == rankingObj.id.int
                {
                    mostOrderedArray.append(RankingModel.init(name: product.name.string!, id: (product.id.int ?? 1), count: rankingObj.order_count.int!))
                }
            }
        }
        mostOrderedArray.sort { (obj1, obj2) -> Bool in
            return obj1.count < obj2.count
        }
    }
    
    func sortByViews() {
        for rankingObj in self.result!.rankings.array![0].products.array! {
            for product in productsArray
            {
                if product.id.int == rankingObj.id.int
                {
                    mostViewedArray.append(RankingModel.init(name: product.name.string!, id: product.id.int!, count: rankingObj.view_count.int!))
                }
            }
        }
        mostViewedArray.sort { (obj1, obj2) -> Bool in
            return obj1.count < obj2.count
        }
    }
    
    func sortByShared() {
        for rankingObj in self.result!.rankings.array![2].products.array! {
            for product in productsArray
            {
                if product.id.int == rankingObj.id.int
                {
                    mostSharedArray.append(RankingModel.init(name: product.name.string!, id: product.id.int!, count: rankingObj.shares.int!))
                }
            }
        }
        mostSharedArray.sort { (obj1, obj2) -> Bool in
            return obj1.count < obj2.count
        }
    }
    
    func findRoot(productsArray : [JSON], category : JSON)
    {
        for catA in productsArray
        {
            if catA.child_categories.array!.count > 0 {
                for childId in catA.child_categories.array!
                {
                    if category.id.int == childId.int
                    {
                        findRoot(productsArray: productsArray, category: catA)
                        self.nodeArray.append(catA)
                    }
                }
            }
        }
    }
    
    func loadTableView() {
        let category = self.rootArray[0] //mens wear
        self.sectionArray.removeAll()
        for subCategory in category.child_categories.array! {
            let section = (self.result?.categories.array)!.filter { (category) -> Bool in
                return (category.id.int == subCategory.int)
            }
            self.sectionArray.append(section[0])
        }
        self.cellArray.removeAll()
        for section in self.sectionArray
        {
            for childCategory in section.child_categories.array!
            {
                let cellArray = (self.result?.categories.array)!.filter { (category) -> Bool in
                    return (category.id.int == childCategory.int)
                }
                self.cellArray.append(SubCategories.init(category: cellArray[0], parent: section.id.int))
            }
        }
        self.categoryTable.separatorStyle = .none
        self.categoryTable.delegate = self
        self.categoryTable.dataSource = self
        self.categoryTable.reloadData()
        
        let productsBunchArray = (self.result!.categories.array?.map({ (categoryObject)  -> [JSON] in
            return categoryObject.products.array!
        }))!
        self.productsArray = productsBunchArray.flatMap { $0 }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subcategoryCollectionView!.register(UINib.init(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        subcategoryCollectionView!.backgroundColor = UIColor.clear
        subcategoryCollectionView!.dataSource = self
        subcategoryCollectionView!.delegate = self
        subcategoryCollectionView!.showsHorizontalScrollIndicator = false
        subcategoryCollectionView!.showsVerticalScrollIndicator = false
        cellType = SortType.Unsorted
        // Do any additional setup after loading the view.
        self.loader.isHidden = false
        self.loader.type = .lineScalePulseOut
        self.loader.backgroundColor = UIColor.white
        self.loader.padding = (self.view.frame.width * 0.8)
        self.loader.color = UIColor.AppColor
        self.loader.startAnimating()
        HTTPMethods.get(url: "https://stark-spire-93433.herokuapp.com/json") { (result, error) in
            self.loader.stopAnimating()
            self.loader.isHidden = true
            if error == nil
            {
                self.result = result
                if let productsArray =  self.result?.categories.array
                {
                    let childArray = productsArray.filter({ (category) -> Bool in
                        return (category.child_categories.array?.count == 0)
                    })
                    for product in childArray
                    {
                        self.findRoot(productsArray: productsArray, category: product)
                        
                        if !(self.rootArray.contains(self.nodeArray[0]))
                        {
                            self.rootArray.append(self.nodeArray[0])
                        }
                        self.nodeArray.removeAll()
                    }
                    self.subcategoryCollectionView.reloadData()
                    self.loadTableView()
                }
            }
            else
            {
                
            }
        }
    }
    
    
}

