//
//  ViewController.swift
//  Gourmand
//
//  Created by MacMini on 2/13/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4
import ParseTwitterUtils
import ParseUI

class ViewController: UIViewController {
 
    @IBOutlet weak var txtEmail: UITextField!
	@IBOutlet weak var txtPass: UITextField!

	override func viewDidLoad() {

		super.viewDidLoad()

//		let hello = NSLocalizedString("hello", comment: "hello")
		// Do any additional setup after loading the view, typically from a nib.



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

//        var gameScore:PFObject?
//
//
//		let query = PFQuery(className: "GameScore")
//        query.getObjectInBackgroundWithId("pVfyfpHAEF", block: { (user : PFObject?,  err :NSError?) -> Void in
//            if err == nil {
//                gameScore = user
//             }
//        })
//
//        if gameScore != nil  {
//            print(gameScore!["score"] as! String)
//            gameScore!["score"] = 200
//            gameScore!.saveInBackground()
//        }
	}

	@IBAction func twitterSignIn(sender: AnyObject) {

		PFTwitterUtils.logInWithBlock {
			(user: PFUser?, error: NSError?) -> Void in
			if let user = user {
				if user.isNew {
					self.updateTwitterUserInfo()
                    self.signIn()
					print("User signed up and logged in with Twitter!")
				} else {
					print("User logged in with Twitter!")
                    self.signIn()
				}
			} else {
				print("Uh oh. The user cancelled the Twitter login.")
			}
		}
	}

	@IBAction func btnSignUp(sender: AnyObject) {
        
        
        		let user = PFUser()
        		user.username = txtEmail.text
        		user.password = txtPass.text
        		user.email = txtEmail.text
        
        		user.signUpInBackgroundWithBlock { (success : Bool, errr: NSError?) -> Void in
        			if errr == nil {
                        self.signIn()
        				// Hooray! Let them use the app now.
        			}
        
        			else {
        				// Examine the error object and inform the user.
        			}
        		}
	}

	@IBAction func facebookSignIn(sender: AnyObject) {

		PFFacebookUtils.logInInBackgroundWithReadPermissions(["email", "user_friends"]) {
			(user: PFUser?, error: NSError?) -> Void in
			if let user = user {
				if user.isNew {
					self.updateFaceBookUserInfo()
                    self.signIn()
					print("User signed up and logged in through Facebook!")
				} else {
                    self.signIn()
					print("User logged in through Facebook!")
				}
			} else {
				print("Uh oh. The user cancelled the Facebook login.")
			}
		}
	}

	@IBAction func btnSignin(sender: UIButton) {
        
        PFUser.logInWithUsernameInBackground(txtEmail.text!, password:txtPass.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.signIn()
                // Do stuff after successful login.
                          } else {
                // The login failed. Check error to see why.
            }
        }
	}
    
    func signIn(){
        self.performSegueWithIdentifier("signedin", sender: self)
}

	func updateTwitterUserInfo() {

		if PFTwitterUtils.isLinkedWithUser(PFUser.currentUser()!) {

			let screenName = PFTwitterUtils.twitter()?.screenName!

			let requestString = ("https://api.twitter.com/1.1/users/show.json?screen_name=" + screenName!)

			let verify: NSURL = NSURL(string: requestString)!

			let request: NSMutableURLRequest = NSMutableURLRequest(URL: verify)

			PFTwitterUtils.twitter()?.signRequest(request)

			var response: NSURLResponse?

			do {

				let data: NSData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)

				do {
					let result = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)

					let names: String! = result.objectForKey("name") as! String

					let separatedNames: [String] = names.componentsSeparatedByString(" ")

					let firstName = separatedNames.first!
					_ = separatedNames.last!

					let urlString = result.objectForKey("profile_image_url_https") as! String

					let hiResUrlString = urlString.stringByReplacingOccurrencesOfString("_normal", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)

					let twitterPhotoUrl = NSURL(string: hiResUrlString)
					let imageData = NSData(contentsOfURL: twitterPhotoUrl!)

					let myUser: PFUser = PFUser.currentUser()!

					myUser.setObject(firstName, forKey: "first_name")

//                // Save email address
//                if(userEmail != nil)
//                {
//                    myUser.setObject(userEmail!, forKey: "email")
//                }

					if (imageData != nil)
					{
						let profileFileObject = PFFile(data: imageData!)
						myUser.setObject(profileFileObject!, forKey: "profile_picture")
					}

					myUser.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in

						if (success)
						{
							print("User details are now updated")
						}
					})
				} catch { }
			} catch { }
		}
	}

	func updateFaceBookUserInfo() {

		let requestParameters = ["fields": "id, email, first_name "]

		let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)

		userDetails.startWithCompletionHandler { (connection, result, error: NSError!) -> Void in

			if (error != nil)
			{
				print("\(error.localizedDescription)")
				return
			}

			if (result != nil)
			{

				let userId: String = result["id"] as! String
				let userFirstName: String? = result["first_name"] as? String
				let userEmail: String? = result["email"] as? String

				print("\(userEmail)")

				let myUser: PFUser = PFUser.currentUser()!

				// Save first name
				if (userFirstName != nil)
				{
					myUser.setObject(userFirstName!, forKey: "first_name")
				}

				// Save email address
				if (userEmail != nil)
				{
					myUser.setObject(userEmail!, forKey: "email")
				}

				dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

					// Get Facebook profile picture
					let userProfile = "https://graph.facebook.com/" + userId + "/picture?type=large"

					let profilePictureUrl = NSURL(string: userProfile)

					let profilePictureData = NSData(contentsOfURL: profilePictureUrl!)

					if (profilePictureData != nil)
					{
						let profileFileObject = PFFile(data: profilePictureData!)
						myUser.setObject(profileFileObject!, forKey: "profile_picture")
					}

					myUser.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in

						if (success)
						{
							print("User details are now updated")
						}
					})
				}
			}
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
