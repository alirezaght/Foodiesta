//
//  DetailCell.swift
//  Gourmand
//
//  Created by alireza ghias on 3/8/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
import Parse
import MBProgressHUD
class DetailCell: UITableViewCell {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var kitchenImage: UIImageView!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var cookName: UILabel!
    @IBOutlet weak var addToCart: UIButton!
    var cook: PFObject?
    @IBAction func addToCartClicked(sender: AnyObject) {
        
        if self.superview != nil{
            MBProgressHUD.showHUDAddedTo(self.superview, animated: true)
        }
        let purchaseService = PurchaseService()
        if(cook != nil){
            purchaseService.purchase(cook!, completeHandler: { (succeed) -> () in
                if(succeed){
                    if(self.superview != nil){
                        MBProgressHUD.hideHUDForView(self.superview, animated: true)
                    }
                    print("purchase succeeded");
                }else{
                    print("purchase failed.")
                }
            })
        }
    }
    
    
}
