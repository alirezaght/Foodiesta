//
//  LocalDb.swift
//  Gourmand
//
//  Created by alireza ghias on 3/1/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
import Parse
class LocalDb{
    //MARK: properties
    var shouldUpdateFromServer = true
    let expireHour = 1
    //MARK: functions
    func getObjects(className: String, includeKeys: [String], completeHandler:([PFObject]?)->()){
        let query = PFQuery(className: className)
        for key in includeKeys{
            query.includeKey(key)
        }
        query.findObjectsInBackgroundWithBlock({(parseObjects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                print("Found \(parseObjects!.count) parseObjects from server")
                completeHandler(parseObjects)
            } else {
                print("Couldn't get objects " + error!.description)
            }
        })
        
    }
    
    
    
    
    func syncFromServer() {
        PFSession.getCurrentSessionInBackgroundWithBlock({(session: PFSession?, error:NSError?) -> Void in
            if(error == nil){
                if(session != nil){
                    if let startDate: NSDate = session!["lastUpdated"] as? NSDate{
                        let endDate = NSDate()
                        let cal = NSCalendar.currentCalendar()
                        let unit: NSCalendarUnit = .Hour
                        let component = cal.components(unit, fromDate: startDate, toDate: endDate, options: [])
                        if (component.hour < self.expireHour){
                            self.shouldUpdateFromServer = false
                        }
                    }
                    if(self.shouldUpdateFromServer){
                        self.getObjects("FoodCategory", includeKeys: [], completeHandler: { categories -> Void in
                            self.getObjects("Ingredient", includeKeys: [], completeHandler: { ingredients -> Void in
                                self.getObjects("Cook", includeKeys: ["user", "food"], completeHandler: { cooks -> Void in
                                    self.getObjects("Food", includeKeys: ["category"], completeHandler: { foods -> Void in
                                        var objects = [PFObject]()
                                        if(categories != nil){
                                            for cat in categories!{
                                                objects.append(cat)
                                            }
                                        }
                                        if(ingredients != nil){
                                            for ing in ingredients!{
                                                objects.append(ing)
                                            }
                                        }
                                        if(cooks != nil){
                                            for cook in cooks!{
                                                objects.append(cook)
                                            }
                                        }
                                        if(foods != nil){
                                            for food in foods!{
                                                objects.append(food)
                                            }
                                        }
                                        PFObject.unpinAllObjectsInBackgroundWithBlock({ (succeeded, error) -> Void in
                                            PFObject.pinAllInBackground(objects, block: { (succeeded: Bool, error: NSError?) -> Void in
                                                if error == nil {
                                                    self.shouldUpdateFromServer = false
                                                    //  session!["lastUpdated"] = NSDate()
                                                    //  session!.saveInBackground()
                                                    
                                                } else {
                                                    print("Failed to pin objects " + error!.description)
                                                }
                                                // First, unpin all existing objects
                                                //                        PFObject.unpinAllInBackground(localObjects, block: { (succeeded: Bool, error: NSError?) -> Void in
                                                //                            if error == nil {
                                                //                                // Pin all the new objects
                                                //                                PFObject.pinAllInBackground(parseObjects, block: { (succeeded: Bool, error: NSError?) -> Void in
                                                //                                    if error == nil {
                                                //                                        // Once we've updated the local datastore, update the view with local datastore
                                                //                                        completeHandler()
                                                //
                                                //                                    } else {
                                                //                                        print("Failed to pin objects " + error!.description)
                                                //                                    }
                                                //                                })
                                                //                            }
                                                //                        })
                                            })
                                        })
                                        
                                    })
                                })
                            })
                        })
                    }
                    
                }
            }
        })
    }
    
    
}