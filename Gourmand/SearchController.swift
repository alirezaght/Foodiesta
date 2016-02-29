//
//  SearchTabController.swift
//  Gourmand
//
//  Created by MacMini on 2/28/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
import SwiftEventBus


let segment_mapView = "select_map"
let segment_tableSearch = "select_table"

class SearchController : UIViewController , UIPageViewControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
  
    @IBAction func indexChanged(sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex
                {
                case 0:
                  NSNotificationCenter.defaultCenter().postNotificationName(segment_tableSearch, object: self)
                case 1:
                     NSNotificationCenter.defaultCenter().postNotificationName(segment_mapView, object: self)
                default:
                    break; 
                }
        
    }
 
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateSegmentControl", name: "pagechangedinpageviewcontroller", object: nil)
    }
    
    func updateSegmentControl(){
        if segmentedControl.selectedSegmentIndex == 1
        {
            segmentedControl.selectedSegmentIndex = 0
        }else {
            segmentedControl.selectedSegmentIndex = 1
        }
    }
    
   
    
   
  
    
    // or
    
    
    
    
    
    
}