//
//  Astronaut.swift
//  MoonLight
//
//  Created by Jay Ramirez on 12/18/24.
//

import SwiftUI

//struct Astronaut: Codable, Identifiable {
struct Astronaut: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
}
