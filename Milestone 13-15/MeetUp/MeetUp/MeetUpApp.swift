//
//  MeetUpApp.swift
//  MeetUp
//
//  Created by Jay Ramirez on 3/27/25.
//

import SwiftUI

@main
struct MeetUpApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Photo.self)
    }
}
