//
//  ViewController+collectionView.swift
//  SAT
//
//  Created by akshay on 17/07/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import Foundation
import UIKit


extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    //MARK:- UICollectionView DataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var expectedLabelSize : CGSize?
        var itemString = ""
        if indexPath.row >= self.rootArray.count
        {
            let index = indexPath.row - self.rootArray.count
            let ranking = self.result!.rankings.array![index]
            itemString = ranking.ranking.string!
        }
        else
        {
            itemString = self.rootArray[indexPath.row].name.string!
        }
        let maximumLabelSize = CGSize(width: CGFloat(184), height: collectionView.frame.height)
        // font
        let font = UIFont.systemFont(ofSize: 13)
        // set paragraph style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        // dictionary of attributes
        //            NSFontAttributeName.
        let attributes  = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let textRect: CGRect = itemString.boundingRect(with: maximumLabelSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let padding = 30.0
        
        
        expectedLabelSize = CGSize(width: CGFloat(ceil(textRect.size.width) + CGFloat(padding)), height: collectionView.frame.height)
        return expectedLabelSize!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let buttonCell = collectionView.cellForItem(at: indexPath)
        if (buttonCell?.frame.origin.x)! > CGFloat.init(200)
        {
            self.subcategoryCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }
        selectedCategory = indexPath.row
        collectionView.reloadData()
        
        if indexPath.row >= self.rootArray.count
        {
            let index = indexPath.row - self.rootArray.count
            print(index)
            print(indexPath.row - self.rootArray.count)
            switch indexPath.row - self.rootArray.count
            {
            case 0:
                self.cellType = SortType.Viewed
                mostViewedArray.removeAll()
                sortByViews()
            case 1:
                self.cellType = SortType.Ordered
                mostOrderedArray.removeAll()
                sortByOrder()
                
            case 2:
                self.cellType = SortType.Shared
                mostSharedArray.removeAll()
                sortByShared()
            default:
                break
            }
            self.expandArray.removeAll()
            self.categoryTable.reloadData()
        }
        else
        {
            self.cellType = SortType.Unsorted
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
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.rootArray.count + (self.result?.rankings.array?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let buttonCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell
        var categoryName = ""
        if indexPath.row >= self.rootArray.count
        {
            let index = indexPath.row - self.rootArray.count
            let ranking = self.result!.rankings.array![index]
            categoryName = ranking.ranking.string!
        }
        else
        {
            categoryName = self.rootArray[indexPath.row].name.string!
        }
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
