//
//  SearchService.swift
//  Gourmand
//
//  Created by alireza ghias on 3/1/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
import Parse
class SearchService{
    var filters: [Filter]
    convenience init(){
        self.init(filters: [Filter]())
    }
    init(filters: [Filter]){
        self.filters = filters
    }
    func addFilter(filter: Filter){
        filters.append(filter)
    }
    func removeAllFilters(){
        filters.removeAll()
    }
    func searchFood(searchQuery: String, completeHandler: ([PFObject]?)->()){
        var catQ = [PFQuery]()
        var ingQ = [PFQuery]()
        for filter in filters{
            switch filter.type{
            case .Category:
                let q = PFQuery(className: "Food")
                q.whereKey("category", equalTo: PFObject(withoutDataWithClassName: "FoodCategory", objectId: filter.objectId))
                catQ.append(q)
                break
            case .Ingredient:
                let q = PFQuery(className: "Cook")
                q.whereKey("ingredients", equalTo: filter.objectId)
                ingQ.append(q)
                break
            }
        }
        
        var query = PFQuery(className: "Food")
        query.includeKey("category")
        if(catQ.count>0){
            query = PFQuery.orQueryWithSubqueries(catQ)
            
        }else{
            
        }
        
        query.whereKey("name", matchesRegex: (".*"+searchQuery+".*"), modifiers: "i")
        query.orderByDescending("popularity").orderByDescending("rating")
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if(error == nil && objects != nil)
            {
                var result = Set<PFObject>()
                
                for obj in objects!{
                    result.insert(obj)
                }
                if(ingQ.count>0){
                    PFQuery.orQueryWithSubqueries(ingQ).fromLocalDatastore().includeKey("food").findObjectsInBackgroundWithBlock({ (cooks, error) -> Void in
                        if(error  == nil && cooks != nil){
                            var resultCook = Set<PFObject>()
                            for cook in cooks!{
                                if let f = cook["food"] as? PFObject{
                                    resultCook.insert(f)
                                }
                            }
                            completeHandler(Array(result.intersect(resultCook)))
                        }
                    })
                    
                }else{
                    completeHandler(objects)
                }
            }else{
                print("could not find objects with query = "+error!.description)
            }
            
        }
    }
    
    
}









