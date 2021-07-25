//
//  Comment+CoreDataProperties.swift
//  
//
//  Created by Guy Nudelman on 16/07/2021.
//
//

import Foundation
import CoreData


extension Comment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var id: String?
    @NSManaged public var userName: String?
    @NSManaged public var userId: String?
    @NSManaged public var productId: String?
    @NSManaged public var lastUpdated: Int64
    @NSManaged public var isRemoved: Bool
    @NSManaged public var desc: String?

}
