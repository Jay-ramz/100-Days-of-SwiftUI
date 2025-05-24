//
//  MapView.swift
//  MeetUp
//
//  Created by Jay Ramirez on 3/27/25.
//

import SwiftUI
import MapKit
import SwiftData

struct MapView: View {
    @Query var photos: [Photo]
    
    var body: some View {
        Map(initialPosition: MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.33233141, longitude: -122.0312186), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))) {
            ForEach(photos) { photo in
                if let coordinate = photo.coordinate {
                    Annotation(photo.name, coordinate: coordinate) {
                        Image(data: photo.photo)!
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(.circle)
                            .padding(5)
                            .background(.white)
                            .clipShape(.circle)
                    }
                }
            }
        }
    }
}

#Preview {
    MapView()
}
