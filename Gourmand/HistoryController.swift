//
//  HistoryTabController.swift
//  Gourmand
//
//  Created by MacMini on 2/28/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
import Parse
import MBProgressHUD

class HistoryController : UIViewController {
    var cooks = [PFObject]()
    func getHistory(){
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let purchaseService = PurchaseService()
        purchaseService.history { (consumers) -> () in
            if consumers != nil{
                for consumer in consumers!{
                    if let cook = consumer["cook"] as? PFObject{
                        self.cooks.append(cook)
                    }
                }
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                var bundle = [NSObject:AnyObject]()
                bundle["result"] = self.cooks
                NSNotificationCenter.defaultCenter().postNotificationName("showHistory", object: self, userInfo: bundle)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(animated: Bool) {
        cooks.removeAll()
        getHistory()
    }
    
    
}