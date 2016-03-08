//
//  SearchResultController.swift
//  Gourmand
//
//  Created by alireza ghias on 3/5/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
import Parse
class SearchResultController: UITableViewController {
    let detailSegue = "showDetailFoods"
    @IBOutlet weak var searchTableView: UITableView!
    var food: PFObject?
    var cooks: [PFObject]?
    var selectedCook: PFObject?
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "searchResultReady:", name: "searchResultReady", object: nil)
    }
    func searchResultReady(notification: NSNotification){
        if let food = notification.userInfo?["result"] as? PFObject{
            self.food = food
            let cookService = CookService()
            var foods = [PFObject]()
            foods.append(food)
            cookService.findCooksByFood(food, completeHandler: { (objects) -> () in
                self.cooks = objects
                self.searchTableView.reloadData()
            })
        }
        
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(cooks != nil){
            return  cooks!.count
        }
        else {
            return 0
        }
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchResultCell") as! SearchResultCell
        if(cooks != nil){
            let cook = cooks![indexPath.row]
            let food = cook["food"] as! PFObject
            let user = cook["user"] as! PFUser
            let file = cook["photo"] as? PFFile
            let cookName = user["first_name"] as! String
            let price = cook["price"] as? Double
            let foodName = food["name"] as! String
            cell.foodName.text = foodName
            cell.cookName.text = cookName
            cell.foodPrice.text = String(price)
            file?.getDataInBackgroundWithBlock({ (data, err) -> Void in
                if(data != nil){
                    let image = UIImage(data: data!)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SearchResultCell
                        cell.foodImage.image = image
                    })
                }
            })
            
            
            
            
            
            
            
        }
        return cell
        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(cooks != nil){
            selectedCook = cooks![indexPath.row]
            performSegueWithIdentifier(detailSegue, sender: self)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier! == detailSegue){
            let dest = segue.destinationViewController as! DetailResultController
            dest.cooks = [selectedCook!]
        }
    }
}