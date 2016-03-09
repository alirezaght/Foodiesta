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
            (cook["photo"] as? PFFile)?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! DetailCell
                if(data != nil){
                    cell.foodImage.image = UIImage(data: data!)
                }
            })
        }catch{}
        do{
            (cook["kitchen"] as? PFFile)?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! DetailCell
                if(data != nil){
                    cell.kitchenImage.image = UIImage(data: data!)
                }
            })
        }catch{}
        let ingredientIds = cook["ingredients"] as! [String]
        var ingredients = [PFObject]()
        for id in ingredientIds{
            do{
                ingredients.append(try PFQuery(className: "Ingredient").fromLocalDatastore().getObjectWithId(id))
            }catch{}
        }
        var count = 0
        for ing in ingredients{
            let yOffset = ((count++)*50)
            let label = UILabel(frame: CGRect(x: 60, y: (25 + yOffset), width: 100, height: 20))
            label.text = ing["name"] as? String
            do{
                if let data = try (ing["photo"] as? PFFile)?.getData(){
                    let ingImage = UIImage(data: data)
                    let imageView = UIImageView(image: ingImage)
                    imageView.frame = CGRect(x: 0, y: yOffset, width: 50, height: 50)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let cell = tableView.cellForRowAtIndexPath(indexPath) as! DetailCell
                        cell.scrollView.addSubview(imageView)
                        print("table cell updated.")
                    })
                    
                }
            }catch{}
            dispatch_async(dispatch_get_main_queue(), { () -> Void in                                                let cell = tableView.cellForRowAtIndexPath(indexPath) as! DetailCell
                cell.scrollView.addSubview(label)
            })
            
        }
        
        return cell
    }
}