//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Jay Ramirez on 2/24/25.
//

import CoreLocation
import Foundation
import LocalAuthentication
import MapKit

extension ContentView {
    @Observable
    
    class ViewModel {
        private(set) var locations: [Location]
        var selectedPlace: Location?
        var isUnlocked = false
        var isShowingAlert = false
        
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New location",
                                       description: "", latitude: point.latitude, longitude:
                                        point.longitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate to unlock places"
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationErorr in
                    if success {
                        self.isUnlocked = true
                    } else {
                    }
                }
            } else {
                self.isShowingAlert = true
                print("Unable to use biometrics")
            }
        }
    }
}
