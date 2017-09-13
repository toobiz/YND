//
//  ImageSet.swift
//  ynd
//
//  Created by Michał Tubis on 12.09.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

import Foundation

class ImageSet {
    
    var _author: String!
    var _id: NSNumber?
    
    var author: String {
        return _author
    }
    
    var id: NSNumber? {
        return _id!
    }
    
    // Initialize new ImageSet
    
    init(dictionary: [String: AnyObject]) {
        if let author = dictionary["author"] {
            self._author = author as! String
        }
        
        if let id = dictionary["id"] {
            self._id = id as? NSNumber
        }
    }
}
