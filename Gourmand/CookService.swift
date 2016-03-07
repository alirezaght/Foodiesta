//
//  CookService.swift
//  Gourmand
//
//  Created by alireza ghias on 3/1/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
import Parse
class CookService {
    func addUserAsCook(user: PFUser, completeHandler: (Bool)->()){
        let isCook = user["isCook"] as? Bool
        if(isCook == nil || !isCook!){
            user["isCook"] = true
            user.saveInBackgroundWithBlock({ (added, error) -> Void in
                if(error == nil){
                    completeHandler(added)
                }else{
                    print("Could not add user as cook "+error!.description)
                }
            })
        }
    }
    func nearbyUsersWhichCanCook(location: PFGeoPoint, withinKilometers: Double, completeHandler: ([PFUser]?)->()){
        let query = PFUser.query()!
        query.whereKey("location", nearGeoPoint: location, withinKilometers: withinKilometers)
        query.whereKey("isCook", equalTo: true)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if(error == nil){
                completeHandler(objects as? [PFUser])
            }else{
                print("could not find cooks query = "+error!.description)
            }
            
        }
        
    }
    func findCooksByFood(food:PFObject, completeHandler: ([PFObject]?)->()){
        let query = PFQuery(className: "Cook")
        query.includeKey("food")
        query.includeKey("user")
        query.fromLocalDatastore()
        query.whereKey("food", equalTo: food)
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if (error == nil && objects != nil){
                completeHandler(objects)
            }else{
                print("could not find cooks by foods query = "+error!.description)
            }
        })
    }
    func findCooksByUser(user:PFUser, completeHandler: ([PFObject]?)->()){
        let query = PFQuery(className: "Cook")
        query.includeKey("food")
        query.includeKey("user")
        query.fromLocalDatastore()
        query.whereKey("user", equalTo: user)
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if (error == nil && objects != nil){
                completeHandler(objects)
            }else{
                print("could not find cooks by users query = "+error!.description)
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
        cook.relationForKey("user").addObject(user)
        cook.relationForKey("food").addObject(food)
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













