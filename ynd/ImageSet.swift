//
//  ImageSet.swift
//  ynd
//
//  Created by Michał Tubis on 12.09.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

import Foundation
import CoreData

@objc (ImageSet)
class ImageSet: NSManagedObject {
    
    @NSManaged var author: String!
    @NSManaged var id: NSNumber?
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    // Initialize new ImageSet
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entity(forEntityName: "ImageSet", in: context)!
        super.init(entity: entity, insertInto: context)

        if let _author = dictionary["author"] {
            self.author = _author as! String
        }
        
        if let _id = dictionary["id"] {
            self.id = _id as? NSNumber
        }
    }
}
