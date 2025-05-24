//
//  Photo.swift
//  MeetUp
//
//  Created by Jay Ramirez on 3/27/25.
//

import Foundation
import SwiftData
import CoreLocation

@Model
class Photo: Identifiable {
    var id = UUID()
    
    @Attribute(.externalStorage) var photo: Data
    
    var name: String
    var longitude: Double?
    var latitude: Double?
    var coordinate: CLLocationCoordinate2D? {
        if let latitude = latitude {
            if let longitude = longitude {
                return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
        }
        return nil
    }
    init(name: String, photo: Data, longitude: Double?, latitude: Double?) {
        self.name = name
        self.photo = photo
        self.longitude = longitude
        self.latitude = latitude
    }
}
