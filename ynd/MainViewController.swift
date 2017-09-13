//
//  MainViewController.swift
//  ynd
//
//  Created by Michał Tubis on 12.09.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var imageSets = [ImageSet]()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        API.sharedInstance().downloadListOfImages { (success, imageSets, error) in
            self.imageSets = imageSets
            DispatchQueue.main.async() {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - TableView delegate

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath as IndexPath) as? ListCell
        
        let imageSet = imageSets[indexPath.row]
        
        if imageSets.count > 0 {
            cell?.listName.text = imageSet.author

        }
        
        if imageSet.filename == nil || imageSet.filename == "" {
            cell?.listImage.image = nil
            print("Image not available")
//        } else if quiz.image != nil {
//            cell?.quizPhoto.image = quiz.image!
//            print("Image retrieved from cache")
        } else {
            API.sharedInstance().downloadImage(urlString: imageSet.filename!, completionHandler: { (success, image, error) in
                if success == true {
                    cell?.listImage.image = image
                }
            })
        }
        
        return cell!
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageSets.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
