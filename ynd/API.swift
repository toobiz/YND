//
//  API.swift
//  ynd
//
//  Created by Michał Tubis on 12.09.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

import UIKit

class API: NSObject {
    
    var session: URLSession
    
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
    
    // MARK: - Unsplash API

    func downloadListOfImages(completionHandler: @escaping (_ success: Bool, _ imageSets: [ImageSet], _ errorString: String?) -> Void) {
        
        let urlString = API.Constants.LIST_URL
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard (error == nil) else {
                print("Connection Error")
                return
            }
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            let parsedResponse = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            
            guard let items = parsedResponse as? [[String:Any]] else {
                print("Cannot find keys 'items' in parsedResponse")
                return
            }
            
//            self.quizzes = self.fetchAllQuizzes()
//            var ids = [NSNumber]()
//
//            for quiz in self.quizzes {
//                ids.append(quiz.id)
//            }
            
            var imageSets = [ImageSet]()
            var authors = [String]()
            
            for item in items {
                
//                print(item)
                
                var authorToAdd = String()
                var idToAdd = NSNumber()
                var filteredAuthors = [String]()

                if let author = item["author"] as? String {
                    if authors.contains(author) {
                        filteredAuthors = authors.filter({ $0 == author })
                    }
                    authors.append(author)
                    authorToAdd = author + " \(filteredAuthors.count + 1)"
                }
                
                if let id = item["id"] {
                    idToAdd = id as! NSNumber
                }
                
                let imageDict: [String: AnyObject] = [
                    "author" : authorToAdd as AnyObject,
                    "id" : idToAdd as AnyObject
                ]
                
                let imageSetToAdd = ImageSet(dictionary: imageDict)
//                print(imageSetToAdd.author)
//                print(imageSetToAdd.id)
                imageSets.append(imageSetToAdd)

//                    let quizToAdd = Quiz(dictionary: quizDict, context: self.sharedContext)
//                    CoreDataStackManager.sharedInstance().saveContext()
//                    self.quizzes.append(quizToAdd)
                }
//
//            }
//            CoreDataStackManager.sharedInstance().saveContext()
            completionHandler(true, imageSets, nil)
            
        }
        task.resume()

    }
    
        func downloadImage(id: NSNumber, completionHandler: @escaping (_ success: Bool, _ image: UIImage, _ errorString: String?) -> Void) {
            let url = NSURL(string: API.Constants.BASE_URL + "300" + API.Constants.IMAGE_URL + String(describing: id))
            let request = NSMutableURLRequest(url: url! as URL)
            let image = UIImage()
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                
                if response != nil {
                        if let image = UIImage(data: data!) {
                            print(url)
                            completionHandler(true, image, nil)
                        } else {
                            completionHandler(false, image, nil)
                    }
                        //                    print(image)
                }
                if let error = error {
                    completionHandler(false, image, error.localizedDescription)
//                } else if data != nil {
//                    let image = UIImage(data: data!)
//                    completionHandler(true, image!, nil)
                }
                
            }
            task.resume()
            
    }
    
}









