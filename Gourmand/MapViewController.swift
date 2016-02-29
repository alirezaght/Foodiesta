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
	var myLocation: CLLocation!

	override func viewDidLoad() {
		super.viewDidLoad()
		let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(48.857165, longitude: 2.354613, zoom: 8.0)
		mapView.camera = camera

		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()

		mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
	}

	func setupUsersInfo() {
		let query = PFUser.query();
		query!.whereKey("getLocationPermission", equalTo: true)
		query!.whereKey("objectId", notEqualTo: PFUser.currentUser()!.objectId!)
		do {
			let users = try query!.findObjects()
			for object in users {

				let coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: object["location"].latitude, longitude: object["location"].longitude)
				setupLocationMarker(coordinate)
			}
		} catch {
			print("erro in marker")
		}
	}

	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if !didFindMyLocation {
			myLocation = change![NSKeyValueChangeNewKey] as! CLLocation
			mapView.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 10.0)
			let user = PFUser.currentUser()!;
			let geoPoint : PFGeoPoint = PFGeoPoint(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude);
			user["location"] = geoPoint ;
			user["getLocationPermission"] = true ;
			user.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
				if (error != nil) {
					print("we have some error")
				}

				if (success)
				{
					print("User location are now updated")
				}
			})
			mapView.settings.myLocationButton = true
			didFindMyLocation = true
			setupUsersInfo();
		}
	}

	func setupLocationMarker(coordinate : CLLocationCoordinate2D) {

		var distance : CLLocationDistance!;
		if didFindMyLocation == true {
			distance = GMSGeometryDistance(coordinate, myLocation.coordinate)
		}

		let locationMarker = GMSMarker(position: coordinate)
		locationMarker.map = mapView;
		locationMarker.title = "Distance :";
		locationMarker.flat = true
		locationMarker.snippet = String(Int(distance))
	}

	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		if status == CLAuthorizationStatus.AuthorizedWhenInUse {
			mapView.myLocationEnabled = true
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		 
	}
}