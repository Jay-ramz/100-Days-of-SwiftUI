//
//  PhotoView.swift
//  MeetUp
//
//  Created by Jay Ramirez on 3/27/25.
//

import SwiftUI

struct PhotoView: View {
    var photo: Photo
    
    var body: some View {
        Image(data: photo.photo)!
            .resizable()
            .scaledToFill()
            .navigationTitle(photo.name)
            .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    PhotoView()
//}
