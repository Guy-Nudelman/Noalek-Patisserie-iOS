//
//  Product+CoreDataProperties.swift
//  Noalek_Patisserie
//
//  Created by Guy Nudelman on 27/05/2021.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var imageUrl: String?
    @NSManaged public var isDairy: Bool
    @NSManaged public var isGlutenFree: Bool
    @NSManaged public var likes: Int16

}

extension Product : Identifiable {

}
