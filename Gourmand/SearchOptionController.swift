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
    var catFilters = [Filter]()
    var ingFilters = [Filter]()
    var count = 0
    var map = [Int:Filter]()
    func reloadData(){
        
        searchOptionTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = SearchOptionService { (filters) -> () in
            self.filters = filters
            for f in filters {
                if f.type == .Category{
                    self.catFilters.append(f)
                }else if f.type == .Ingredient{
                    self.ingFilters.append(f)
                }
            }
            self.reloadData()
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("searchOptionCell") as! SearchOptionCell
        let filter: Filter
        if(indexPath.section == 0){
            filter = ingFilters[indexPath.row]
        }else{
            filter = catFilters[indexPath.row]
        }
        cell.label.text = filter.name
        cell.filterSwitch.on = false
        cell.filterSwitch.tag = count
        map[count] = filter
        count++
        cell.filter = filter
        return cell
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "Ingredients"
        }else{
            return "Categories"
        }
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return ingFilters.count
        }else {
            return catFilters.count
        }
    }
    
    
    @IBAction func switchChanged(sender: UISwitch) {
        let filter = map[sender.tag]!
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