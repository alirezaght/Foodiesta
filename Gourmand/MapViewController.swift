//
//  viewMapController.swift
//  Gourmand
//
//  Created by MacMini on 2/16/16.
//  Copyright © 2016 MacMini. All rights reserved.
//

import Foundation
import GoogleMaps

class MapViewController : UIViewController {
	 
 
    @IBOutlet weak var mapView: GMSMapView!

	override func viewDidLoad() {
		super.viewDidLoad()
		let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(48.857165, longitude: 2.354613, zoom: 8.0)
		mapView.camera = camera
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}