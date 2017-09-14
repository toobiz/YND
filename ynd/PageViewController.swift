//
//  PageViewController.swift
//  ynd
//
//  Created by Michał Tubis on 14.09.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var imageSets = [ImageSet]()
    var currentIndex = NSInteger()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setViewControllers([getViewControllerAtIndex(index: currentIndex)] as [UIViewController], direction: .forward, animated: true, completion: nil)
    }
    
    // MARK: - PageView Data Source
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getViewControllerAtIndex(index: currentIndex)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return getViewControllerAtIndex(index: currentIndex)
    }
    
    func getViewControllerAtIndex(index: NSInteger) -> DetailViewController {
        
        let detailView = self.storyboard?.instantiateViewController(withIdentifier: "Details") as! DetailViewController
        detailView.id = imageSets[index].id!
        detailView.author = "Example"
        detailView.pageIndex = index
        return detailView
    }

}
