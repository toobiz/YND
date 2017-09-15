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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    // MARK: - TableView delegate

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ListCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath as IndexPath) as? ListCell
        
        cell?.selectionStyle = .none
        let imageSet = imageSets[indexPath.row]
        
        if imageSets.count > 0 {
            cell?.listName.text = imageSet.author

        }
        
        if imageSet.id == nil {
            cell?.listImage.image = nil
            print("Image not available")
//        } else if quiz.image != nil {
//            cell?.quizPhoto.image = quiz.image!
//            print("Image retrieved from cache")
        } else {
            cell?.listImage.image = #imageLiteral(resourceName: "placeholder")
            API.sharedInstance().downloadImage(id: imageSet.id!, width: 300, completionHandler: { (success, image, error) in
                if success == true {
//                    if let cellToUpdate = tableView.cellForRow(at: indexPath) as? ListCell {
//                        quiz.image = resizedImage
                        DispatchQueue.main.async(execute: {
//                            cell?.listImage.image = nil
                            cell?.listImage.image = image
                            cell?.setNeedsLayout()
                        });
//                    }
                } else {
//                    DispatchQueue.main.async(execute: {
                        cell?.listImage.image = #imageLiteral(resourceName: "placeholder")
//                    });
                    
                }
            })
        }
        
        return cell!
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageSets.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imageSet = imageSets[indexPath.row]
//        let detailView = storyboard?.instantiateViewController(withIdentifier: "Details") as! DetailViewController
//        detailView.id = imageSet.id!
//        detailView.author = imageSet.author
        
        let pageView = storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
        pageView.imageSets = imageSets
        pageView.currentIndex = indexPath.row
        
        navigationController?.pushViewController(pageView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

}
