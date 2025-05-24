//
//  AddPhotoView.swift
//  MeetUp
//
//  Created by Jay Ramirez on 3/27/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddPhotoView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedPhoto: Image?
    @State private var name = ""
    
    let locationFetcher = LocationFetcher()
    
    var body: some View {
        VStack {
            Spacer()
            PhotosPicker(selection: $pickerItem, matching: .images) {
                if selectedPhoto == nil {
                    ContentUnavailableView("No Picture", systemImage: "photo.badge.plus", description: Text("Tap to import photo"))
                } else {
                    selectedPhoto!
                        .resizable()
                        .scaledToFit()
                }
            }
            .onChange(of: pickerItem) {
                Task {
                    selectedPhoto = try await pickerItem?.loadTransferable(type: Image.self)
                }
            }
            Spacer()
            TextField("Write a title of this photo", text: $name)
                .font(.title)
        }
        .padding()
        .onAppear(perform: {
            locationFetcher.start()
        })
        .toolbar {
            Button("Save") {
                Task {
                    guard let imageData = try await pickerItem?.loadTransferable(type: Data.self) else { return }
                    if let location = locationFetcher.lastKnownLocation {
                        print("Your location is \(location)")
                        let newPhoto = Photo(name: name, photo: imageData, longitude: location.longitude, latitude: location.latitude)
                        modelContext.insert(newPhoto)
                    } else {
                        print("Your location is unknown")
                        let newPhoto = Photo(name: name, photo: imageData, longitude: nil, latitude: nil)
                        modelContext.insert(newPhoto)
                    }
                }
                dismiss()
            }
            .disabled(name == "" || pickerItem == nil)
        }
    }
}

#Preview {
    AddPhotoView()
}
