//
//  CookService.swift
//  Gourmand
//
//  Created by alireza ghias on 3/1/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
class CookService {
    func addUserAsCook(user: PFUser, completeHandler: (Bool)->()){
        let isCook = user["isCook"] as? Bool
        if(isCook == nil || !isCook!){
            user["isCook"] = true
            user.saveInBackgroundWithBlock({ (added, error) -> Void in
                if(error == nil){
                    completeHandler(added)
                }else{
                    print("Could not add user as cook")
                }
            })
        }
    }
    func nearbyUsersWhichCanCook(location: PFGeoPoint, withinKilometers: Double, completeHandler: ([PFUser]?)->()){
        let query = PFUser.query()!
        query.whereKey("location", nearGeoPoint: location, withinKilometers: withinKilometers)
        query.whereKey("isCook", equalTo: true)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if(error != nil){
                completeHandler(objects as? [PFUser])
            }else{
                print("could not find cooks query = "+query.description)
            }
            
        }
        
    }
    func findCooksByUsers(users:[PFUser], completeHandler: ([PFObject]?)->()){
        let query = PFQuery(className: "Cook")
        query.fromLocalDatastore()
        query.whereKey("user", containedIn: users)
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if (error == nil && objects != nil){
                completeHandler(objects)
            }else{
                print("could not find foods by cooks query = "+query.description)
            }
        })
    }
    func findFoodsByUsers(users:[PFUser], completeHandler: ([PFObject]?)->()){
        var foods = [PFObject]()
        let query = PFQuery(className: "Cook")
        query.fromLocalDatastore()
        query.whereKey("user", containedIn: users)
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if (error == nil && objects != nil){
                for cook in objects!{
                    if let food = cook["food"] as? PFObject{
                        foods.append(food)
                    }
                }
                foods.sortInPlace({ (obj1, obj2) -> Bool in
                    var pop1 = obj1["popularity"] as? Int
                    if(pop1 == nil){
                        pop1 = 0
                    }
                    var pop2 = obj2["popularity"] as? Int
                    if(pop2 == nil){
                        pop2 = 0
                    }
                    var rate1 = obj1["rating"] as? Int
                    if(rate1 == nil){
                        rate1 = 0
                    }
                    var rate2 = obj2["rating"] as? Int
                    if(rate2 == nil){
                        rate2 = 0
                    }
                    return pop1!+rate1! > pop2!+rate2!
                    
                })
                completeHandler(foods)
            }else{
                print("could not find foods by cooks query = "+query.description)
            }
        })
    }
    
    func userCooks(user: PFUser, food: PFObject, completeHandler: (Bool)->()){
        guard user["isCook"] as? Bool == true else{
            print("user is not a cook, trying to add user as cook...")
            addUserAsCook(user, completeHandler: { (result) -> () in
                if(result){
                    print("user added as cook, continuing userCooks method!")
                    self.userCooks(user, food: food, completeHandler: completeHandler)
                }else{
                    print("Could not add user as cook!!")
                }
            })
            return
        }
        let cook = PFObject(className: "Cook")
        let userRelation = PFRelation()
        userRelation.addObject(user)
        cook["user"] = userRelation
        let foodRelation = PFRelation()
        foodRelation.addObject(food)
        cook["food"] = foodRelation
        cook.saveInBackgroundWithBlock { (result, error) -> Void in
            if(error == nil){
                completeHandler(result)
            }
        }
        
    }
    func userRevokeCook(cook: PFObject, completeHandler: (Bool)->()){
        cook.deleteInBackgroundWithBlock { (result, error) -> Void in
            if(error == nil){
                completeHandler(result)
            }else{
                print("Could not delete cook "+error!.description)
            }
        }
    }
    
    
    
    
    
    
}













