//
//  LocationFetcher.swift
//  MeetUp
//
//  Created by Jay Ramirez on 3/27/25.
//


// Challenge: A new feature needs to be introduced. When viewing a picture that was imported, you should show a map with a pin that marks where they were when that picture was added
// Challenge Part II: How are you integrating mapKit? Examples to consider - The same screen side by side the photo, shown or hidden using a segmented control, or on a different screen

import Foundation
import CoreLocation

class LocationFetcher: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
    }

    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
}
