//
//  SearchService.swift
//  Gourmand
//
//  Created by alireza ghias on 3/1/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
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
                q.whereKey("category", containsString: filter.objectId)
                catQ.append(q)
                break
            case .Ingredient:
                let q = PFQuery(className: "Food")
                q.whereKey("ingredients", containsString: filter.objectId)
                ingQ.append(q)
                break
            }
        }
        let query = PFQuery.orQueryWithSubqueries(catQ)
        query.whereKey("objectId", matchesKey: "objectId", inQuery: PFQuery.orQueryWithSubqueries(ingQ))
        query.whereKey("name", containsString: searchQuery)
        query.whereKey("name", containsString: searchQuery)
        query.orderByDescending("popularity").orderByDescending("rating")
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if(error == nil)
            {
                completeHandler(objects)
            }else{
                print("could not find objects with query = "+query.description)
            }
            
        }
    }
    
    
}









