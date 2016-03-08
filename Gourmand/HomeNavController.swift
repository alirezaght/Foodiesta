//
//  HomeNavController.swift
//  Gourmand
//
//  Created by MacMini on 3/8/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation

class HomeNavController: UINavigationController {
	override func viewDidLoad() {
        super.viewDidLoad()
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "actOnSpecialNotification", name:"goToDetail", object: nil)
    
        
       
//        
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: "hi:")
       
        
        
        
    }
    
    func actOnSpecialNotification() {
//        self.navigationController? .setNavigationBarHidden(false, animated:true)
//        let backButton = UIButton(type: UIButtonType.ContactAdd)
//        backButton.addTarget(self, action: "popToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
//        backButton.setTitle("TITLE", forState: UIControlState.Normal)
//        backButton.sizeToFit()
//        let backButtonItem = UIBarButtonItem(customView: backButton)
//        self.navigationItem.leftBarButtonItem = backButtonItem
        
        self.setNavigationBarHidden(false, animated:true)
        performSegueWithIdentifier("DetailResultController", sender: nil)
    }

    
    
//    func popToRoot(sender:UIBarButtonItem){
//        self.navigationController?.popToRootViewControllerAnimated(true)
//    }
}