//
//  API.swift
//  ynd
//
//  Created by Michał Tubis on 12.09.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

import UIKit
import CoreData

class API: NSObject {
    
    var session: URLSession
    var imageSets = [ImageSet]()
    
    override init() {
        session = URLSession.shared
        super.init()
    }

    // MARK: - Shared Instance
    
    class func sharedInstance() -> API {
        struct Singleton {
            static var sharedInstance = API()
        }
        return Singleton.sharedInstance
    }
    
    // MARK: - Core Data
    
    lazy var sharedContext: NSManagedObjectContext =  {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    func fetchAll() -> [ImageSet] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageSet")
        
        do {
            return try sharedContext.fetch(fetchRequest) as! [ImageSet]
        } catch  let error as NSError {
            print("Error in fetchAll(): \(error)")
            return [ImageSet]()
        }
    }
    
    // MARK: - Unsplash API

    func downloadListOfImages(completionHandler: @escaping (_ success: Bool, _ imageSets: [ImageSet], _ errorString: String?) -> Void) {
        
        self.imageSets = self.fetchAll()
        
        if Reachability.isConnectedToNetwork() == true {
        
        let urlString = API.Constants.LIST_URL
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard (error == nil) else {
                print("Connection Error")
                completionHandler(false, self.imageSets, "Connection Error")
                return
            }
            guard let data = data else {
                print("No data was returned by the request!")
                completionHandler(false, self.imageSets, "No data was returned by the request!")
                return
            }
            let parsedResponse = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            
            guard let items = parsedResponse as? [[String:Any]] else {
                print("Cannot find keys 'items' in parsedResponse")
                return
            }
            
            var ids = [NSNumber]()

            for imageSet in self.imageSets {
                ids.append(imageSet.id!)
            }
            
            var authors = [String]()
            
            for item in items {
                
                var idToAdd = NSNumber()
                
                if let id = item["id"] {
                    idToAdd = id as! NSNumber
                }
                
                if ids.contains(idToAdd) {
                    
                } else {
                    print("Adding to Core Data")
                    
                    var authorToAdd = String()
                    var filteredAuthors = [String]()
                    
                    if let author = item["author"] as? String {
                        if authors.contains(author) {
                            filteredAuthors = authors.filter({ $0 == author })
                        }
                        authors.append(author)
                        authorToAdd = author + " \(filteredAuthors.count + 1)"
                    }
                    
                    let imageDict: [String: AnyObject] = [
                        "author" : authorToAdd as AnyObject,
                        "id" : idToAdd as AnyObject
                    ]
                    
                    let imageSetToAdd = ImageSet(dictionary: imageDict, context: self.sharedContext)
                    CoreDataStackManager.sharedInstance().saveContext()
                    self.imageSets.append(imageSetToAdd)
                }
                
            }
            CoreDataStackManager.sharedInstance().saveContext()
            completionHandler(true, self.imageSets, nil)
            
        }
        task.resume()
            
        } else {
            completionHandler(false, imageSets, "Internet Connection not Available!")
        }
    }
    
    func downloadImage(id: NSNumber, width: CGFloat, completionHandler: @escaping (_ success: Bool, _ image: UIImage, _ errorString: String?) -> Void) {
        
        let image = UIImage()
        let url = NSURL(string: API.Constants.BASE_URL + String(describing: width) + API.Constants.IMAGE_URL + String(describing: id))
        let request = NSMutableURLRequest(url: url! as URL)
        
        if Reachability.isConnectedToNetwork() == true {
            
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                
                if response != nil {
                    if let image = UIImage(data: data!) {
                        completionHandler(true, image, nil)
                    } else {
                        completionHandler(false, image, nil)
                    }
                }
                if let error = error {
                    completionHandler(false, image, error.localizedDescription)
                }
            }
            task.resume()
        } else {
            completionHandler(false, image, "Internet Connection not Available!")
        }
    }
    
}









