//
//  ViewController.swift
//  SAT
//
//  Created by Akshay Gawade on 11/07/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import UIKit
import DynamicJSON



extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    //MARK:- UICollectionView DataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var expectedLabelSize : CGSize?
        
        let itemString = self.rootArray[indexPath.row].name.string
        let maximumLabelSize = CGSize(width: CGFloat(184), height: collectionView.frame.height)
        // font
        let font = UIFont.systemFont(ofSize: 13)
        // set paragraph style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        // dictionary of attributes
        //            NSFontAttributeName.
        let attributes  = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let textRect: CGRect = itemString!.boundingRect(with: maximumLabelSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let padding = 30.0
        
        
        expectedLabelSize = CGSize(width: CGFloat(ceil(textRect.size.width) + CGFloat(padding)), height: collectionView.frame.height)
        return expectedLabelSize!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = indexPath.row
        collectionView.reloadData()
        let category = self.rootArray[indexPath.row] //mens wear
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
        self.expandArray.removeAll()
        self.categoryTable.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.rootArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let buttonCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell
        let categoryName = self.rootArray[indexPath.row].name.string
        
        buttonCell!.categoryName.text = categoryName
        if selectedCategory == indexPath.row
        {
            buttonCell?.selectedView.isHidden = false
        }
        else
        {
            buttonCell?.selectedView.isHidden = true
        }
        
        return buttonCell!
        
    }
}


extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.sectionArray.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.expandArray.contains(section)
        {
            let products = self.sectionArray[section]
            let cellForSection = self.cellForSection(section: products.id.int!)
            return (cellForSection.count + 1)
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "categoryCell")
        }
        if indexPath.row == 0
        {
            let products = self.sectionArray[indexPath.section]
            cell.backgroundColor = UIColor(red:0.29, green:0.40, blue:0.52, alpha:1.0)
            cell.textLabel?.text = products.name.string
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        }
        else
        {
            let products = self.sectionArray[indexPath.section]
            let cellForSection = self.cellForSection(section: products.id.int!)
            let cellModel = cellForSection[indexPath.row - 1]
            cell.backgroundColor = UIColor(red:0.47, green:0.55, blue:0.64, alpha:1.0)
            cell.textLabel?.text = cellModel.category!.name.string
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0
        {
            if self.expandArray.contains(indexPath.section)
            {
                self.expandArray.removeAll { (element) -> Bool in
                    element == indexPath.section
                }
            }
            else
            {
                self.expandArray.append(indexPath.section)
            }
            tableView.reloadSections([indexPath.section], with: .automatic)
        }
    }
    
    func cellForSection(section: Int) -> [SubCategories] {
        let cellForSection = self.cellArray.filter({ (cellModel) -> Bool in
            return (cellModel.parent == section)
        })
        return cellForSection
    }
}






struct SubCategories {
    var category : JSON?
    var parent : Int?
}


class ViewController: UIViewController {
    @IBOutlet weak var subcategoryCollectionView: UICollectionView!
    @IBOutlet weak var categoryTable: UITableView!
    var result : JSON?
    var sectionArray = [JSON]()
    var cellArray = [SubCategories]()
    var nodeArray = [JSON]()
    var rootArray = [JSON]()
    var expandArray = [Int]()
    var selectedCategory = 0
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subcategoryCollectionView!.register(UINib.init(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        subcategoryCollectionView!.backgroundColor = UIColor.clear
        subcategoryCollectionView!.dataSource = self
        subcategoryCollectionView!.delegate = self
        subcategoryCollectionView!.showsHorizontalScrollIndicator = false
        subcategoryCollectionView!.showsVerticalScrollIndicator = false
        
        // Do any additional setup after loading the view.
        HTTPMethods.get(url: "https://stark-spire-93433.herokuapp.com/json") { (result, error) in
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
                    print(self.rootArray.count)
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

