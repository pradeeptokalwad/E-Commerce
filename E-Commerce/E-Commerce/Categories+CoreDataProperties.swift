//
//  Categories+CoreDataProperties.swift
//  E-Commerce
//
//  Created by webwerks on 11/11/17.
//  Copyright © 2017 PT. All rights reserved.
//
//

import Foundation
import CoreData


extension Categories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Categories> {
        return NSFetchRequest<Categories>(entityName: "Categories")
    }

    @NSManaged public var parentCatID: Int64
    @NSManaged public var parentCatName: String?
    @NSManaged public var productlist: NSSet?

}

// MARK: Generated accessors for productlist
extension Categories {

    @objc(addProductlistObject:)
    @NSManaged public func addToProductlist(_ value: Products)

    @objc(removeProductlistObject:)
    @NSManaged public func removeFromProductlist(_ value: Products)

    @objc(addProductlist:)
    @NSManaged public func addToProductlist(_ values: NSSet)

    @objc(removeProductlist:)
    @NSManaged public func removeFromProductlist(_ values: NSSet)

}
