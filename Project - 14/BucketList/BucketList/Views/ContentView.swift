//
//  ContentView.swift
//  BucketList
//
//  Created by Jay Ramirez on 2/18/25.
//

import MapKit
import SwiftUI

struct ContentView: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    @State private var viewModel = ViewModel()
    @State private var isStandardMap = true
    
    var body: some View {
        if viewModel.isUnlocked {
            ZStack {
                MapReader { proxy in
                    Map(initialPosition: startPosition) {
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .simultaneousGesture(LongPressGesture(minimumDuration: 1).onEnded { _ in viewModel.selectedPlace = location
                                    })
                            }
                        }
                    }
                    .mapStyle(isStandardMap ? .standard : .hybrid)
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                }
                .sheet(item: $viewModel.selectedPlace) { place in
                    EditView(location: place) {
                        viewModel.update(location: $0)
                    }
                }
                VStack { // Challenge #1: Allow user to change from hybrid to standard
                    Spacer()
                    Button(isStandardMap ? "Change to Hybrid" : "Change to Standard") {
                        isStandardMap.toggle()
                    }
                    .padding()
                    .background(.white)
                    .clipShape(.capsule)
                    .buttonStyle(.plain)
                }
            }
        } else {
            Button("Unlock places") {
                viewModel.authenticate()
            }
            .buttonStyle(.borderedProminent)
            .alert("Unable to use biometrics", isPresented: $viewModel.isShowingAlert) {
                Button("Okay", role: .cancel) { }
            } message: {
                Text("Please check your settings.")
            }
        }
    }
}
#Preview {
    ContentView()
}
