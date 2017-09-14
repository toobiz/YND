//
//  DetailViewController.swift
//  ynd
//
//  Created by Michał Tubis on 13.09.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    var id = NSNumber()
    var author = String()
    var pageIndex = NSInteger()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
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

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
