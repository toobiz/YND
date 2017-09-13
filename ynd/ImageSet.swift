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
    var _filename: String?
    
    var author: String {
        return _author
    }
    
    var filename: String? {
        return _filename!
    }
    
    // Initialize new ImageSet
    
    init(dictionary: [String: String]) {
        if let author = dictionary["author"] {
            self._author = author
        }
        
        if let filename = dictionary["filename"] {
            self._filename = filename
        }
    }
}
