//
//  User.swift
//  SwiftDataProject
//
//  Created by Jay Ramirez on 1/16/25.
//

import Foundation
import SwiftData

@Model
class User {
    var name: String = "Anonymous"
    var city: String = "Unknown"
    var joinDate: Date = Date.now
    @Relationship(deleteRule: .cascade) var jobs: [Job]? = [Job]()
    
    var unwrappedJobs: [Job] {
        jobs ?? []
    }
   
    init(name: String, city: String, joinDate: Date) {
        self.name = name
        self.city = city
        self.joinDate = joinDate
    }
}
