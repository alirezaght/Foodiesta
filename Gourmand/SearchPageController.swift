//
//  SearchPageController.swift
//  Gourmand
//
//  Created by MacMini on 2/28/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation

import UIKit
import tolo
import SwiftEventBus

let notification = "pagechangedinpageviewcontroller"

class SearchPageController : UIPageViewController {
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                direction: .Forward,
                animated: true,
                completion: nil)
                    }
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "selectSecondPage", name: "select_map", object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "selectFirstPage", name: "select_table", object: nil)

        
       
    }
    
    func selectFirstPage(){
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                direction: .Reverse ,
                animated: true,
                completion: nil)
        }
    }
    
    func selectSecondPage(){
        if let lastViewController = orderedViewControllers.last {
            setViewControllers([lastViewController],
                direction: .Forward,
                animated: true,
                completion: nil)
        }
    }
    
    
    
    private(set) lazy  var orderedViewControllers: [UIViewController] = {
        return [self.newColoredViewController("SearchTable"),
            self.newColoredViewController("MapView")]
    }()
    
    private func newColoredViewController(color: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewControllerWithIdentifier("\(color)")
    }
    

    
}




// MARK: UIPageViewControllerDataSource

extension SearchPageController : UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
                return nil
            }
            
            let previousIndex = viewControllerIndex - 1
            
            guard previousIndex >= 0 else {
                return nil
            }
            
            guard orderedViewControllers.count > previousIndex else {
                return nil
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName(notification,object: self)
            return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
                return nil
            }
            
            let nextIndex = viewControllerIndex + 1
            let orderedViewControllersCount = orderedViewControllers.count
            
            guard orderedViewControllersCount != nextIndex else {
                return nil
            }
            
            guard orderedViewControllersCount > nextIndex else {
                return nil
            }
            NSNotificationCenter.defaultCenter().postNotificationName(notification,object: self)
            return orderedViewControllers[nextIndex]
    }
    
}