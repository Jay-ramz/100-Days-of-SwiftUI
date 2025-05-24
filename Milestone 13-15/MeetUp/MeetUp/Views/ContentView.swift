//
//  ContentView.swift
//  MeetUp
//
//  Created by Jay Ramirez on 3/27/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
//    let locationFetcher = LocationFetcher()
    
    @Query(sort: \Photo.name) var photos: [Photo]
    
    @State private var image: Image?
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(photos) { photo in
                        NavigationLink(destination: PhotoView(photo: photo)) {
                            VStack {
                                Image(data: photo.photo)!
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 150)
                                Text(photo.name)
                            }
                        }
                    }
                }
            }
            .toolbar {
                NavigationLink("Add a photo") {
                    AddPhotoView()
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
