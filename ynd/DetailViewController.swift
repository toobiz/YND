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

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authorLabel.text = author
        imageView.image = #imageLiteral(resourceName: "placeholder")
        
        API.sharedInstance().downloadImage(id: id, width: imageView.bounds.width, height: imageView.bounds.height) { (success, image, error) in
            if success == true {

                DispatchQueue.main.async(execute: {
                    self.imageView.image = image
                });
            }
        }

    }

    

}
