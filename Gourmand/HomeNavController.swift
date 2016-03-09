//
//  HomeNavController.swift
//  Gourmand
//
//  Created by MacMini on 3/8/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
import Parse

class HomeNavController: UINavigationController {

	var cooks = [PFObject]()
	override func viewDidLoad() {
		super.viewDidLoad()
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "actOnSpecialNotification:", name: "goToDetail", object: nil)
		self.setNavigationBarHidden(false, animated: true)
		let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.redColor()]
		self.navigationBar.titleTextAttributes = titleDict as! [String : AnyObject]
		self.navigationBar.tintColor = UIColor.redColor()
	}

	func actOnSpecialNotification(notification : NSNotification) {

		let userInfo: Dictionary<String, String!> = notification.userInfo as! Dictionary<String, String!>
		let cookId = userInfo["cookId"]

		let query : PFQuery = PFQuery(className: "Cook")
		query.getObjectInBackgroundWithId(cookId!) { (object : PFObject?, error: NSError?) -> Void in
			if error == nil {
				self.cooks.append(object!)
                self.topViewController?.title = ""
				self.performSegueWithIdentifier("DetailResultController", sender: self)
			}
		}
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "DetailResultController" {
			let viewController = segue.destinationViewController as! DetailResultController
			viewController.cooks = self.cooks
		}
	}
}