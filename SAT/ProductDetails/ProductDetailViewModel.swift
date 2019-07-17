//
//  ProductDetailViewModel.swift
//  SAT
//
//  Created by akshay on 16/07/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import Foundation
import DynamicJSON
import DropDown

class ProductDetailViewModel {
    var controller : ProductDetailController?
    var productObj : JSON?
    var name : String? {
        willSet{
            self.controller?.nameLbl.text = ""
        }
        didSet{
            self.controller?.nameLbl.text = self.name
        }
    }
    var colorArray : [String] = [] {
        didSet{
            for view in self.controller!.colorViews {
                
                view.layer.borderWidth = 1
                view.layer.borderColor = UIColor.clear.cgColor
            }
            let colorsCount = self.colorArray.count
            for index in 60..<(60 + colorsCount){
                let colorView = self.controller?.view.viewWithTag(index)
                    switch (self.colorArray[(index - 60)]) {
                case "Blue":
                    
                    colorView?.layer.borderColor = UIColor.AppColor.cgColor
                    colorView?.backgroundColor = UIColor.blue
                case "Red":
                    
                    colorView?.layer.borderColor = UIColor.AppColor.cgColor
                    colorView?.backgroundColor = UIColor.red
                case "Black":
                    
                    colorView?.layer.borderColor = UIColor.AppColor.cgColor
                    colorView?.backgroundColor = UIColor.black
                case "Brown":
                    
                    colorView?.layer.borderColor = UIColor.AppColor.cgColor
                    colorView?.backgroundColor = UIColor.brown
                case "Silver":
                    
                    colorView?.layer.borderColor = UIColor.AppColor.cgColor
                    colorView?.backgroundColor = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0)
                case "Golden":
                    
                    colorView?.layer.borderColor = UIColor.AppColor.cgColor
                    colorView?.backgroundColor = UIColor(red:1.00, green:0.84, blue:0.00, alpha:1.0)
                case "Grey":
                    
                    colorView?.layer.borderColor = UIColor.AppColor.cgColor
                    colorView?.backgroundColor = UIColor.gray
                case "White":
                    
                    colorView?.layer.borderColor = UIColor.AppColor.cgColor
                    colorView?.backgroundColor = UIColor.white
                default:
                    colorView?.isHidden = true
                    colorView?.layer.borderColor = UIColor.clear.cgColor
                    colorView?.isHidden = true
                }
            }
        }
    }
    var variants : [JSON] = [] {
        didSet{
            if self.variants[0].size.int != nil
            {
                let sizes = self.variants.map{ "\( $0.size.int!)" }
                self.controller?.dropDown.dataSource = sizes
                self.controller?.dropView.text = "\(sizes[0]) ▼"
            }

        }
    }
    
    
    var selectedSize = 0 {
        didSet{
            
        }
    }
    var price : Double? {
        willSet{
            self.controller?.priceLbl.text = "₹ \(0.0)"
        }
        didSet{
            self.controller?.priceLbl.text = "₹ \(self.price!) (including tax)"
        }
    }
    var tax = 0
    
    init(productObj: JSON, controller: ProductDetailController) {
        self.productObj = productObj
        self.controller = controller
        self.fillData()
    }
    
    func fillData()  {
        self.name = self.productObj!.name.string!
        if self.productObj!.variants.array!.count > 0
        {
            self.price = (self.productObj!.variants.array![0].price.double)! + self.productObj!.tax.value.double!
        }
        self.variants = (self.productObj!.variants.array)!
        
        
         let withoutSizeVarient = self.variants.filter({ (variants) -> Bool in
            return variants.size.int == nil
        })
        if withoutSizeVarient.count > 0
        {
            let colorArray = withoutSizeVarient.map{ $0.color.string! }
            print(colorArray)
            self.colorArray = colorArray
        }
        else
        {
        let colorArray =  self.variants[0].color.string!
        self.colorArray = [colorArray]
        }
    }
    
}
