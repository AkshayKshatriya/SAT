//
//  ViewController+tableview.swift
//  SAT
//
//  Created by akshay on 16/07/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import Foundation
import DynamicJSON


extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (self.cellType as! SortType) == SortType.Unsorted
        {
            return (self.sectionArray.count)
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.cellType as! SortType
        {
        case SortType.Viewed:
            return self.mostViewedArray.count
        case SortType.Ordered:
            return self.mostOrderedArray.count
        case SortType.Shared:
            return self.mostSharedArray.count
        case .Unsorted:
            if self.expandArray.contains(section)
            {
                let products = self.sectionArray[section]
                let cellForSection = self.cellForSection(section: products.id.int!)
                return (cellForSection.count + 1)
            }
            return 1
        }
        //        }
        //        else if self.expandArray.contains(section)
        //        {
        //            let products = self.sectionArray[section]
        //            let cellForSection = self.cellForSection(section: products.id.int!)
        //            return (cellForSection.count + 1)
        //        }
        //        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "categoryCell")
        }
        cell.selectionStyle = .none
        
        switch self.cellType as! SortType
        {
        case .Unsorted:
            if indexPath.row == 0
            {
                let products = self.sectionArray[indexPath.section]
                cell.backgroundColor = UIColor.AppColor
                cell.textLabel?.text = products.name.string
                cell.textLabel?.textColor = UIColor.white
                cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
                cell.detailTextLabel?.text = ""
            }
            else
            {
                let products = self.sectionArray[indexPath.section]
                let cellForSection = self.cellForSection(section: products.id.int!)
                let cellModel = cellForSection[indexPath.row - 1]
                cell.backgroundColor = UIColor.SecondaryColor
                cell.textLabel?.text = cellModel.category!.name.string
                cell.textLabel?.textColor = UIColor.white
                cell.textLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
                cell.detailTextLabel?.text = ""
            }
            
        case SortType.Viewed:
            let products = self.mostViewedArray[indexPath.row]
            cell.backgroundColor = UIColor.AppColor
            cell.textLabel?.text = products.name
            cell.detailTextLabel?.text = "Views: \(products.count)"
            cell.detailTextLabel?.textColor = UIColor(red:0.82, green:0.85, blue:0.88, alpha:1.0)
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        case SortType.Ordered:
            let products = self.mostOrderedArray[indexPath.row]
            cell.backgroundColor = UIColor.AppColor
            cell.textLabel?.text = products.name
            cell.detailTextLabel?.text = "Orders: \(products.count)"
            cell.detailTextLabel?.textColor = UIColor(red:0.82, green:0.85, blue:0.88, alpha:1.0)
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        case SortType.Shared:
            let products = self.mostSharedArray[indexPath.row]
            cell.backgroundColor = UIColor.AppColor
            cell.textLabel?.text = products.name
            cell.detailTextLabel?.text = "Shared: \(products.count)"
            cell.detailTextLabel?.textColor = UIColor(red:0.82, green:0.85, blue:0.88, alpha:1.0)
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.cellType as! SortType
        {
        case .Unsorted:
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
            else
            {
                let products = self.sectionArray[indexPath.section]
                let cellForSection = self.cellForSection(section: products.id.int!)
                let cellModel = cellForSection[indexPath.row - 1]
                let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                let browseProductController = storyBoard.instantiateViewController(withIdentifier: "BrowseProductController") as? BrowseProductController
                browseProductController?.productsArray = cellModel.category!.products.array!
                self.navigationController?.pushViewController(browseProductController!, animated: true)
            }
            
        case .Viewed:
            let productid = self.mostViewedArray[indexPath.row].id
            let products = self.productsArray.filter { (product) -> Bool in
                return (product.id.int == productid)
            }
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let productDetailController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailController") as? ProductDetailController
            productDetailController?.productObj = products[0]
            self.navigationController?.pushViewController(productDetailController!, animated: true)
        case .Ordered:
            let productid = self.mostOrderedArray[indexPath.row].id
            let products = self.productsArray.filter { (product) -> Bool in
                return (product.id.int == productid)
            }
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let productDetailController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailController") as? ProductDetailController
            productDetailController?.productObj = products[0]
            self.navigationController?.pushViewController(productDetailController!, animated: true)
        case .Shared:
            let productid = self.mostSharedArray[indexPath.row].id
            let products = self.productsArray.filter { (product) -> Bool in
                return (product.id.int == productid)
            }
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let productDetailController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailController") as? ProductDetailController
            productDetailController?.productObj = products[0]
            self.navigationController?.pushViewController(productDetailController!, animated: true)
            
        }
    }
    
    func cellForSection(section: Int) -> [SubCategories] {
        let cellForSection = self.cellArray.filter({ (cellModel) -> Bool in
            return (cellModel.parent == section)
        })
        return cellForSection
    }
}

