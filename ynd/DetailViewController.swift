//
//  DetailViewController.swift
//  ynd
//
//  Created by Michał Tubis on 13.09.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
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
        
        if id == nil {
            imageView?.image = #imageLiteral(resourceName: "placeholder")
            print("Image not available")
        } else if imageSets[currentIndex].image != nil {
            imageView.image = imageSets[currentIndex].image!
            print("Image retrieved from cache")
        } else {
            API.sharedInstance().downloadImage(id: id!, width: view.frame.size.width) { (success, image, error) in
                DispatchQueue.main.async(execute: {
                    self.imageView.image = image
                    if error != nil {
                        self.showAlert(message: error!)
                    }
                });
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // MARK: - Helpers
    
    func showAlert(message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true){}
    }
}
