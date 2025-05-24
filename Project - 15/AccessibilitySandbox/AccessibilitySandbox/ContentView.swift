//
//  ContentView.swift
//  AccessibilitySandbox
//
//  Created by Jay Ramirez on 2/27/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button("John Fitzgerald Kennedy") {
            print("Button tapped")
        }
        .accessibilityInputLabels(["John Fitzgerald Kennedy, Kennedy, JFK"])
    }
}

#Preview {
    ContentView()
}
