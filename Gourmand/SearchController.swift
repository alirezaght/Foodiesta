//
//  SearchTabController.swift
//  Gourmand
//
//  Created by MacMini on 2/28/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
import SwiftEventBus


class SearchController : UIViewController , UIPageViewControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
//    
//    
//    @IBAction func indexChanged(sender: UISegmentedControl) {
//        
//        switch segmentedControl.selectedSegmentIndex
//        {
//        case 0:
//           var a = 2
//        case 1:
//           var b = 3
//        default:
//            break; 
//        }
//        
//    }
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftEventBus.onMainThread(segmentedControl, name: "someEventName") { result in
             var a = 3
        }
        
        
   
    }
    
   
  
    
    // or
    
    
    
    
    
    
}