//
//  viewMapController.swift
//  Gourmand
//
//  Created by MacMini on 2/16/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
import GoogleMaps
import Parse
class MapViewController : UIViewController, CLLocationManagerDelegate {

	@IBOutlet weak var mapView: GMSMapView!
    
    
    let locationManager = CLLocationManager()
    var didFindMyLocation = false

	override func viewDidLoad() {
		super.viewDidLoad()
		let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(48.857165, longitude: 2.354613, zoom: 8.0)
		mapView.camera = camera

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
 

		mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
	}

	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>)  {
		if !didFindMyLocation {
			let myLocation: CLLocation = change![NSKeyValueChangeNewKey] as! CLLocation
			mapView.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 10.0)
            let user = PFUser.currentUser();
            let geoPoint = PFGeoPoint(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude);
            user?.addObject( geoPoint , forKey: "location" )
            user?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                
                if (success)
                {
                    print("User location are now updated")
                }
            })
			mapView.settings.myLocationButton = true
			didFindMyLocation = true
		}
	}

	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		if status == CLAuthorizationStatus.AuthorizedWhenInUse {
			mapView.myLocationEnabled = true
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}