//
//  SearchTabController.swift
//  Gourmand
//
//  Created by MacMini on 2/28/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation


let segment_mapView = "select_map"
let segment_tableSearch = "select_table"

class SearchController : UIViewController , UIPageViewControllerDelegate, UINavigationControllerDelegate, UISearchBarDelegate {
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var searchOptionContainer: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: SearchBar!

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
        searchContainer.hidden = true
        segmentedControl.hidden = true
        searchOptionContainer.hidden = false
        searchBar.showOptions = { ()->() in
            self.searchContainer.hidden = true
            self.segmentedControl.hidden = true
            self.searchOptionContainer.hidden = false
        }
        searchBar.showResult = { ()->() in
            self.searchContainer.hidden = false
            self.segmentedControl.hidden = false
            self.searchOptionContainer.hidden = true
        }
        searchBar.filterDelegate = {
            return SearchOptionController.selectedFilters
        }
        searchBar.searchDelegate = { (food)->() in
            var bundle = [NSObject:AnyObject]()
            bundle["result"] = food
            NSNotificationCenter.defaultCenter().postNotificationName("searchResultReady", object: self, userInfo: bundle)
        }
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