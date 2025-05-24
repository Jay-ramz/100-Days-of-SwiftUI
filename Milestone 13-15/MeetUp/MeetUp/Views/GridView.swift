//
//  GridView.swift
//  MeetUp
//
//  Created by Jay Ramirez on 3/27/25.
//

import SwiftUI
import SwiftData

struct GridView: View {
    @Query(sort: \Photo.name) var photos: [Photo]
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    var body: some View {
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
    }
}

#Preview {
    GridView()
}
