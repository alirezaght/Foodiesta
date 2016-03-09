//
//  DetailResultController.swift
//  Gourmand
//
//  Created by alireza ghias on 3/8/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
import Parse
class DetailResultController: UITableViewController {
    let detailCell = "detailCell"
    var cooks = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = " Detial "
        
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cooks.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(detailCell) as! DetailCell
        let cook = cooks[indexPath.row]
        cell.cook = cook
        cell.cookName.text = cook["user"]["first_name"] as? String
        do{
            cell.foodImage.image = UIImage(data: try (cook["photo"] as! PFFile).getData())
        }catch{}
        do{
            cell.kitchenImage.image = UIImage(data: try (cook["kitchen"] as! PFFile).getData())
        }catch{}
        let ingredientIds = cook["ingredients"] as! [String]
        var ingredients = [PFObject]()
        for id in ingredientIds{
            do{
                ingredients.append(try PFQuery(className: "Ingredient").getObjectWithId(id))
            }catch{}
        }
        for ing in ingredients{
            let label = UILabel()
            label.text = ing["name"] as? String
            cell.ingredientView.addSubview(label)
        }
        return cell
    }
    
    
    
}