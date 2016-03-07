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
    
    @IBOutlet weak var searchTableView: UITableView!
    var food: PFObject?
    var cooks: [PFObject]?
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
            do{
                let cook = cooks![indexPath.row]
                let food = cook["food"] as! PFObject
                let user = cook["user"] as! PFUser
                let photoQuery = PFQuery(className: "Photo")
                photoQuery.whereKey("food", equalTo: food)
                let photo = try photoQuery.getFirstObject()
                let file = photo["image"] as! PFFile
                let cookName = user["first_name"] as! String
                let price = food["price"] as! Int
                let foodName = food["name"] as! String
                cell.foodName.text = foodName
                cell.cookName.text = cookName
                cell.foodPrice.text = String(price)
                let image = UIImage(data: try file.getData(), scale: 0)
                cell.imageView?.clipsToBounds = true
                cell.imageView?.image = image
                	
                
                
            }catch{
                
            }
            
        }
        return cell
        
    }
}