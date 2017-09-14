//
//  DetailViewController.swift
//  ynd
//
//  Created by Michał Tubis on 13.09.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
//    var id = NSNumber()
//    var author = String()
    var currentIndex = Int()
    var imageSets = [ImageSet]()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        
        imageView.image = #imageLiteral(resourceName: "placeholder")

        authorLabel.text = imageSets[currentIndex].author
        let id = imageSets[currentIndex].id
        
        API.sharedInstance().downloadImage(id: id!, width: imageView.bounds.width, height: imageView.bounds.height) { (success, image, error) in
            
            if success == true {
                
                DispatchQueue.main.async(execute: {
                    self.imageView.image = image
                });
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        

    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
