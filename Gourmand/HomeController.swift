//
//  HomeTabController.swift
//  Gourmand
//
//  Created by MacMini on 2/28/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
import Parse

class HomeController : UIViewController {
    
    @IBOutlet weak var container: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        
//        let query : PFQuery = PFQuery(className: "Cook")
//        query.includeKey("user");
//        query.includeKey("food");
//        query.findObjectsInBackgroundWithBlock { (  objects:  [PFObject]?, err : NSError?) -> Void in
//            if err == nil{
//                for item in objects!{
//                var a = item["type"]
//                var b = item["photo"]
//                var c = item["food"]["name"]
//                }
//            }
//        }
        
        
        
     
        
        
        
        
        
        
        
        let vc = (storyboard?.instantiateViewControllerWithIdentifier("HomeViewMosaic"))! as UIViewController
        self.addChildViewController(vc)
        vc.view.frame = CGRectMake(0 ,  0 , self.container.frame.size.width, self.container.frame.size.height)
        self.container.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }

}
