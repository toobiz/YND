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
                var filenameToAdd = String()
                var filteredArray = [String]()

                if let author = item["author"] as? String {
                    if authors.contains(author) {
//                        let results = authors.map({ $0.lowercased().contains(author) })
                        filteredArray = authors.filter({ $0 == author })
                        print(filteredArray.count)
                        authorToAdd = author + " \(filteredArray.count + 1)"
                    }
                    authors.append(author)
                    authorToAdd = author + " \(filteredArray.count + 1)"
                }
                
                if let filename = item["filename"] {
                    filenameToAdd = filename as! String
                }
                
                let imageDict: [String: String] = [
                    "author" : authorToAdd,
                    "filename" : filenameToAdd
                ]
                
                let imageSetToAdd = ImageSet(dictionary: imageDict)
                print(imageSetToAdd.author)
                print(imageSetToAdd.filename)
                imageSets.append(imageSetToAdd)
                
//                if ids.contains(idToAdd) {
//                    print("Already in Core Data")
//                } else {
//                    print("Adding quiz to Core Data")
//                    
//                    var titleToAdd = String()
//                    var urlToAdd = String()
//                    
//                    if let title = item["title"] as? String {
//                        titleToAdd = title
//                    }
//                    
//                    if let photoDict = item["mainPhoto"] as? [String:Any] {
//                        urlToAdd = photoDict["url"] as! String
//                    }
//
//                    let quizDict: [String : AnyObject] = [
//                        "id" : idToAdd as AnyObject,
//                        "title" : titleToAdd as AnyObject,
//                        "urlString" : urlToAdd as AnyObject
//                    ]
                
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
    
}
