//
//  PurchaseService.swift
//  Gourmand
//
//  Created by alireza ghias on 3/9/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
import Parse
class PurchaseService {
    func purchase(cook: PFObject, completeHandler: (Bool)->()){
        if let user = PFUser.currentUser(){
            let consumer = PFObject(className: "ConsumerHistory")
            consumer["user"] = user
            consumer["cook"] = cook
            consumer.saveInBackgroundWithBlock({ (succeed, error) -> Void in
                completeHandler(succeed)
            })
        }
    }
    func history(completeHandler:([PFObject]?->())){
        if let user = PFUser.currentUser(){
            let query = PFQuery(className: "ConsumerHistory")
            query.whereKey("user", equalTo: user)
            query.includeKey("user")
            query.includeKey("cook")
            query.includeKey("cook.user")
            query.includeKey("cook.food")
            
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if(error == nil){
                    completeHandler(objects)
                }else{
                    print("Purchase History failed "+error!.description)
                }
            })
        }
        completeHandler(nil)
    }
}