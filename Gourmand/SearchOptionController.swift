//
//  SearchOptionController.swift
//  Gourmand
//
//  Created by alireza ghias on 3/5/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
class   SearchOptionController: UITableViewController{
    @IBOutlet var searchOptionTableView: UITableView!
    var filters = [Filter]()
    static var selectedFilters = [Filter]()
    func reloadData(){
        
        searchOptionTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = SearchOptionService { (filters) -> () in
            self.filters = filters
            self.reloadData()
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("searchOptionCell") as! SearchOptionCell
        let filter = filters[indexPath.row]
        cell.label.text = filter.name
        cell.filterSwitch.on = false
        cell.filterSwitch.tag = indexPath.row
        cell.filter = filter
        return cell
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
  
    @IBAction func switchChanged(sender: UISwitch) {
        let filter = filters[sender.tag]
        if(sender.on){
            SearchOptionController.selectedFilters.append(filter)
        }else{
            if let index = SearchOptionController.selectedFilters.indexOf({ (f) -> Bool in
                return f.objectId == filter.objectId
            }){
                SearchOptionController.selectedFilters.removeAtIndex(index)
            }
        }

    }
    
}