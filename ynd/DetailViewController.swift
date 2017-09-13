//
//  DetailViewController.swift
//  ynd
//
//  Created by Michał Tubis on 13.09.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var id = NSNumber()
    var author = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(author)
        print(String(describing: id))

    }

    

}
