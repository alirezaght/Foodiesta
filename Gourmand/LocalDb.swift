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
    func syncQuery(className: String, completeHandler:()->()){
        let localQuery = PFQuery(className: className)
        let query = PFQuery(className: className)
        localQuery.fromLocalDatastore()
        localQuery.findObjectsInBackgroundWithBlock({(parseObject localObjects: [PFObject]?, error: NSError?) -> Void in
            if(error == nil){
                query.findObjectsInBackgroundWithBlock({( parseObjects: [PFObject]?, error: NSError?) -> Void in
                    if error == nil {
                        print("Found \(parseObjects!.count) parseObjects from server")
                        // First, unpin all existing objects
                        PFObject.unpinAllInBackground(localObjects, block: { (succeeded: Bool, error: NSError?) -> Void in
                            if error == nil {
                                // Pin all the new objects
                                PFObject.pinAllInBackground(parseObjects, block: { (succeeded: Bool, error: NSError?) -> Void in
                                    if error == nil {
                                        // Once we've updated the local datastore, update the view with local datastore
                                        completeHandler()
                                        
                                    } else {
                                        print("Failed to pin objects")
                                    }
                                })
                            }
                        })
                    } else {
                        print("Couldn't get objects")
                    }
                })
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
                        self.syncQuery("FoodCategory", completeHandler: {
                            self.syncQuery("Ingredient", completeHandler: {
                                self.syncQuery("Cook", completeHandler: {
                                    self.syncQuery("Food", completeHandler: {
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