//
//  Products+CoreDataProperties.swift
//  E-Commerce
//
//  Created by webwerks on 11/11/17.
//  Copyright © 2017 PT. All rights reserved.
//
//

import Foundation
import CoreData


extension Products {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Products> {
        return NSFetchRequest<Products>(entityName: "Products")
    }

    @NSManaged public var categoryID: Int64
    @NSManaged public var categoryName: String?
    @NSManaged public var productID: Int64
    @NSManaged public var productName: String?
    @NSManaged public var productTaxName: String?
    @NSManaged public var productTaxValue: Float
    @NSManaged public var productImageURL: String?
    @NSManaged public var ranking: String?
    @NSManaged public var shareCount: Int64
    @NSManaged public var viewdCount: Int64
    @NSManaged public var orderedCount: Int64
    @NSManaged public var variants: NSSet?

}

// MARK: Generated accessors for variants
extension Products {

    @objc(addVariantsObject:)
    @NSManaged public func addToVariants(_ value: Variants)

    @objc(removeVariantsObject:)
    @NSManaged public func removeFromVariants(_ value: Variants)

    @objc(addVariants:)
    @NSManaged public func addToVariants(_ values: NSSet)

    @objc(removeVariants:)
    @NSManaged public func removeFromVariants(_ values: NSSet)

}
