//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by Jay Ramirez on 4/16/25.
//

import SwiftData
import SwiftUI

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Prospect.self)
    }
}
