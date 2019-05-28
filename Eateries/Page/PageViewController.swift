//
//  PageViewController.swift
//  Eateries
//
//  Created by Aleksei Chudin on 04/02/2019.
//  Copyright © 2019 Aleksei Chudin. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var headersArray = ["Record", "Find"]
    var subheadersArray = ["Create your list of favourite restaurants", "Find and mark on the map your favourite restaurants"]
    var imagesArray = ["food", "iphoneMap"]

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        if let firstVC = displayViewController(atIndex: 0) {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func displayViewController(atIndex index: Int) -> ContentViewController? {
        guard index >= 0 else { return nil }
        guard index < headersArray.count else { return nil }
        guard let contentVC = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController else { return nil }
        
        contentVC.imageFile = imagesArray[index]
        contentVC.header = headersArray[index]
        contentVC.subheader = subheadersArray[index]
        contentVC.index = index
        
        return contentVC
    }
    
    func nextVC(atIndex index: Int) {
        if let contentVC = displayViewController(atIndex: index+1) {
            setViewControllers([contentVC], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index -= 1
        return displayViewController(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index
        index += 1
        return displayViewController(atIndex: index)
    }
    // standart horizontal page scroll
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return headersArray.count
//    }
//
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        let contentVC = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController
//        return contentVC!.index
//    }
}
