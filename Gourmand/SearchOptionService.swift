//
//  SearchOptionService.swift
//  Gourmand
//
//  Created by alireza ghias on 3/5/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
import Parse
class SearchOptionService{
    
    var filters = [Filter]()
    init(completeHandler: ([Filter])->()){
        let ingQ = PFQuery(className: "Ingredient")
        ingQ.fromLocalDatastore()
        ingQ.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if(objects != nil){
                for obj in objects!{
                    self.filters.append(Filter(type: .Ingredient, objectId: obj.objectId!, name: obj["name"] as! String))
                }
            }
            let catQ = PFQuery(className: "FoodCategory")
            catQ.fromLocalDatastore()
            catQ.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                
                if(objects != nil){
                    for obj in objects!{
                        self.filters.append(Filter(type: .Category, objectId: obj.objectId!, name: obj["name"] as! String))
                    }
                }
                completeHandler(self.filters)
                
            })
        }
    }
}