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
        }catch let err as NSError {
            print(err.debugDescription)
        }
        return aryCategory as NSArray
    }
    
    func fetchAllRanking() -> NSArray {
        
        var aryRanking  = [[String:Any]]()

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        
        do {
            fetchRequest.resultType = .dictionaryResultType
            fetchRequest.propertiesToFetch = ["ranking"]
            fetchRequest.returnsDistinctResults = true
            aryRanking = try managedObjectContext.fetch(fetchRequest) as! [[String : Any]]
        }catch let err as NSError {
            print(err.debugDescription)
        }
        return aryRanking as NSArray
    }
    
    func fetchRankingWiseData(strRanking: NSString) -> NSArray {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        var aryProducts  = [Products]()
        
        fetchRequest.predicate = NSPredicate(format: "ranking == %@", strRanking.lowercased)
        
        if strRanking.isEqual(to: "Most Viewed Products".lowercased()) {
            let sort = NSSortDescriptor(key: #keyPath(Products.viewdCount), ascending: false)
            fetchRequest.sortDescriptors = [sort]

        }else if strRanking.isEqual(to: "Most ShaRed Products".lowercased()) {
            let sort = NSSortDescriptor(key: #keyPath(Products.shareCount), ascending: false)
            fetchRequest.sortDescriptors = [sort]

        }else if strRanking.isEqual(to: "Most OrdeRed Products".lowercased()) {
            let sort = NSSortDescriptor(key: #keyPath(Products.orderedCount), ascending: false)
            fetchRequest.sortDescriptors = [sort]
        }

        do {
            aryProducts = try managedObjectContext.fetch(fetchRequest) as! [Products]
        }catch let err as NSError {
            print(err.debugDescription)
        }
        
        return aryProducts as NSArray
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
            let entityProducts = NSEntityDescription.entity(forEntityName: "Products", in: managedObjectContext)
            let product = Products(entity: entityProducts!, insertInto: managedObjectContext)
            product.productName = ((dictParam as AnyObject).value(forKey: "name") as? String) ?? ""
            product.productID = ((dictParam as AnyObject).value(forKey: "id") as? Int64) ?? 0
            product.categoryID = Int64(catID)
            product.productImageURL = "https://www.dropbox.com/s/hmg7q3riru0a1cd/shoe.jpeg?dl=1"
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
    
    func rankingOfProducts(dictParam: NSDictionary) {
        
        let strKey = dictParam.value(forKey: "ranking") as! NSString
        let aryRankingProducts = dictParam["products"] as! NSArray
      
        for product in aryRankingProducts {
            let pID = (product as! NSDictionary).value(forKey: "id") as! NSInteger
            if strKey.isEqual(to: "Most Viewed Products") {
                let countV = (product as! NSDictionary).value(forKey: "view_count") as! NSInteger
                updateProductRanking(ranking:strKey , rankingCount: countV, productID: pID, paramName: "view_count")
            }else if strKey.isEqual(to: "Most ShaRed Products") {
                let countV = (product as! NSDictionary).value(forKey: "shares") as! NSInteger
                updateProductRanking(ranking:strKey , rankingCount: countV, productID: pID, paramName: "shares")
            }else if strKey.isEqual(to: "Most OrdeRed Products") {
                let countV = (product as! NSDictionary).value(forKey: "order_count") as! NSInteger
                updateProductRanking(ranking:strKey , rankingCount: countV, productID: pID, paramName: "order_count")
            }
        }
    }
    
    func updateProductRanking(ranking: NSString, rankingCount: NSInteger, productID: NSInteger, paramName: NSString) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Products")
        fetchRequest.predicate = NSPredicate(format: "productID == %d", productID)
        var aryProducts  = [Products]()

        do {
            aryProducts = try managedObjectContext.fetch(fetchRequest) as! [Products]
            let productForRanking = aryProducts[0] as Products
            productForRanking.ranking = (ranking as String).lowercased()
            
            if paramName.isEqual(to: "view_count") {
                productForRanking.viewdCount = Int64(rankingCount)
            }else if paramName.isEqual(to: "order_count") {
                productForRanking.orderedCount = Int64(rankingCount)
            }else if paramName.isEqual(to: "shares") {
                productForRanking.shareCount = Int64(rankingCount)
            }
            try managedObjectContext.save()
            
        }catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
}
