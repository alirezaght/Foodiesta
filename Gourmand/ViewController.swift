//
//  ViewController.swift
//  Gourmand
//
//  Created by MacMini on 2/13/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
//		let hello = NSLocalizedString("hello", comment: "hello")
		// Do any additional setup after loading the view, typically from a nib.

		let user = PFUser()
		user.username = "userName"
		user.password = "password"
		user.email = "example@mail.com"
		user["phone"] = "1234-5678-9123"

		user.signUpInBackgroundWithBlock { (success : Bool, errr: NSError?) -> Void in
			if errr == nil {
				// Hooray! Let them use the app now.
			}

			else {
				// Examine the error object and inform the user.
			}
		}

//        let gameScore = PFObject(className:"GameScore")
//        gameScore["score"] = 1337
//        gameScore["playerName"] = "Sean Plott"
//        gameScore["cheatMode"] = false
//        gameScore.saveInBackgroundWithBlock {
//            (success: Bool, error: NSError?) -> Void in
//            if (success) {
//                // The object has been saved.
//            } else {
//                // There was a problem, check error.description
//            }
//        }

        var gameScore:PFObject?
        

		let query = PFQuery(className: "GameScore")
        query.getObjectInBackgroundWithId("pVfyfpHAEF", block: { (user : PFObject?,  err :NSError?) -> Void in
            if err == nil {
                gameScore = user
             }
        })

        if gameScore != nil  {
            print(gameScore!["score"] as! String)
            gameScore!["score"] = 200
            gameScore!.saveInBackground()
        }
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
