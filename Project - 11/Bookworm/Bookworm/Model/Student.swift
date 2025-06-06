//
//  Student.swift
//  Bookworm
//
//  Created by Jay Ramirez on 1/10/25.
//

import Foundation
import SwiftData

@Model
class Student {
    var id: UUID
    var name: String
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
