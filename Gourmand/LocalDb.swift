//
//  LocalDb.swift
//  Gourmand
//
//  Created by alireza ghias on 3/1/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
class LocalDb{
    //MARK: properties
    var shouldUpdateFromServer = true
    let expireHour = 1
    //MARK: functions
    func syncQuery(className: String, includeKeys: [String], completeHandler:()->()){
        let query = PFQuery(className: className)
        for key in includeKeys{
            query.includeKey(key)
        }
        query.findObjectsInBackgroundWithBlock({(parseObject localObjects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                print("Found \(localObjects!.count) parseObjects from server")
                PFObject.pinAllInBackground(localObjects, withName: className, block: { (succeeded: Bool, error: NSError?) -> Void in
                    if error == nil {
                        completeHandler()
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
                        self.syncQuery("FoodCategory", includeKeys: [], completeHandler: {
                            self.syncQuery("Ingredient", includeKeys: [], completeHandler: {
                                self.syncQuery("Cook", includeKeys: ["user", "food"], completeHandler: {
                                    self.syncQuery("Food", includeKeys: ["category"], completeHandler: {
                                        self.shouldUpdateFromServer = false
                                        session!["lastUpdated"] = NSDate()
                                        session!.saveInBackground()
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