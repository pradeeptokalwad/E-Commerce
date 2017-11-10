//
//  Variants+CoreDataProperties.swift
//  E-Commerce
//
//  Created by webwerks on 11/11/17.
//  Copyright © 2017 PT. All rights reserved.
//
//

import Foundation
import CoreData


extension Variants {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Variants> {
        return NSFetchRequest<Variants>(entityName: "Variants")
    }

    @NSManaged public var color: String?
    @NSManaged public var price: Float
    @NSManaged public var size: Float
    @NSManaged public var vID: Int64

}
