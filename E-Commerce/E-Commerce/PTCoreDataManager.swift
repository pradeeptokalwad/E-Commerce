//
//  PTCoreDataManager.swift
//  Demo
//
//  Created by webwerks on 11/10/17.
//  Copyright © 2017 PT. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct PTCoreDataManager {
    static let sharedInstance = PTCoreDataManager()

    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func fetchAllCategories() -> NSArray {
        
        var aryCategory  = [Categories]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        
        
        do {
            aryCategory = try managedObjectContext.fetch(fetchRequest) as! [Categories]
//            for cate in aryCategory {
//                print(cate)
//            }
        }catch let err as NSError {
            print(err.debugDescription)
        }
        return aryCategory as NSArray

    }
    func addCategory(dictParam: NSDictionary) {
        
        let entityCategories = NSEntityDescription.entity(forEntityName: "Categories", in: managedObjectContext)
        let categories = Categories(entity: entityCategories!, insertInto: managedObjectContext)
        
        categories.parentCatName = (dictParam.value(forKey: "name") as? String) ?? ""
        categories.parentCatID = (dictParam.value(forKey: "id") as? Int64) ?? 0
        
        let aryProducts = dictParam.value(forKey: "products") as! NSArray
        
        addProductInCategory(categoryToAdd: categories, aryProduct: aryProducts, catName: categories.parentCatName! as NSString, catID: NSInteger(categories.parentCatID))
        
        do{
            try managedObjectContext.save()
        }catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func addProductInCategory(categoryToAdd: Categories, aryProduct: NSArray, catName: NSString, catID: NSInteger) {
        
        for dictParam in aryProduct {
            print("product=\(dictParam)")
            let entityProducts = NSEntityDescription.entity(forEntityName: "Products", in: managedObjectContext)
            let product = Products(entity: entityProducts!, insertInto: managedObjectContext)
            product.productName = ((dictParam as AnyObject).value(forKey: "name") as? String) ?? ""
            product.productID = ((dictParam as AnyObject).value(forKey: "id") as? Int64) ?? 0
            product.categoryID = Int64(catID)
            product.categoryName = catName as String
            product.productTaxName = ((dictParam as AnyObject).value(forKey: "tax") as! NSDictionary).value(forKey: "name") as? String
            product.productTaxValue = (((dictParam as AnyObject).value(forKey: "tax") as! NSDictionary).value(forKey: "value") as? Float) ?? 0
            let aryVariants = (dictParam as AnyObject).value(forKey: "variants") as! NSArray
            addVariantInProduct(productToAdd: product, aryVariants: aryVariants)
            
            categoryToAdd.addToProductlist(product)
        }
    }
    
    func addVariantInProduct(productToAdd: Products, aryVariants: NSArray) {
        for varinat in aryVariants {
            print("Variants=\(varinat)")
            let entityProducts = NSEntityDescription.entity(forEntityName: "Variants", in: managedObjectContext)
            let varinatObj = Variants(entity: entityProducts!, insertInto: managedObjectContext)
            varinatObj.vID = (varinat as AnyObject).value(forKey: "id") as! Int64
            varinatObj.color = (varinat as AnyObject).value(forKey: "color") as? String
            varinatObj.size = ((varinat as AnyObject).value(forKey: "size") as? Float) ?? 0
            varinatObj.price = ((varinat as AnyObject).value(forKey: "price") as? Float) ?? 0
            productToAdd.addToVariants(varinatObj)
        }
    }
    
    func addProduct(dictParam: NSDictionary, catName: NSString, catID: NSInteger) {
        
        let entityProducts = NSEntityDescription.entity(forEntityName: "Products", in: managedObjectContext)
        let product = Products(entity: entityProducts!, insertInto: managedObjectContext)
        product.productName = dictParam.value(forKey: "name") as? String
        product.productID = (dictParam.value(forKey: "id") as? Int64)!
        product.categoryID = Int64(catID)
        product.categoryName = catName as String
        product.productTaxName = (dictParam.value(forKey: "tax") as! NSDictionary).value(forKey: "name") as? String
        product.productTaxValue = ((dictParam.value(forKey: "tax") as! NSDictionary).value(forKey: "value") as? Float) ?? 0

        let aryVariants = dictParam.value(forKey: "variants") as! NSArray
        for varinat in aryVariants {
            print("Variants=\(varinat)")
            let entityProducts = NSEntityDescription.entity(forEntityName: "Variants", in: managedObjectContext)
            let varinatObj = Variants(entity: entityProducts!, insertInto: managedObjectContext)
            varinatObj.vID = (varinat as AnyObject).value(forKey: "id") as! Int64
            varinatObj.color = (varinat as AnyObject).value(forKey: "color") as? String
            varinatObj.size = ((varinat as AnyObject).value(forKey: "size") as? Float) ?? 0
            varinatObj.price = ((varinat as AnyObject).value(forKey: "price") as? Float) ?? 0
            product.addToVariants(varinatObj)
        }
        do{
            try managedObjectContext.save()
        }catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
//    func fetxhData() {
//        let fetchedResultController = NSFetchedResultsController(fetchRequest: Products.fetchRequest(), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
//           return  fetchedResultController
//        }
}
