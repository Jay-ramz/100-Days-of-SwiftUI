//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Jay Ramirez on 1/10/25.
//

import SwiftData
import SwiftUI

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
