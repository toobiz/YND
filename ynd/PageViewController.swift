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
    var currentIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        
        setViewControllers([getViewControllerAtIndex(index: currentIndex)] as [UIViewController], direction: .forward, animated: true, completion: nil)
    }
    
    // MARK: - PageView Data Source
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let detailView: DetailViewController = viewController as! DetailViewController
        var index = detailView.currentIndex
        if ((index == 0) || (index == NSNotFound)) {
            return nil
        }
        index -= 1
        currentIndex -= 1
        return getViewControllerAtIndex(index: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let detailView: DetailViewController = viewController as! DetailViewController
        var index = detailView.currentIndex

        if (index == NSNotFound) {
            return nil;
        }
        index += 1
        currentIndex += 1
        if (index == imageSets.count) {
            return nil;
        }
        return getViewControllerAtIndex(index: index)
    }
    
    func getViewControllerAtIndex(index: NSInteger) -> DetailViewController {
        
        let detailView = self.storyboard?.instantiateViewController(withIdentifier: "Details") as! DetailViewController
        detailView.imageSets = imageSets
        detailView.currentIndex = index
        return detailView
    }

}
