//
//  Book.swift
//  Bookworm
//
//  Created by Jay Ramirez on 1/13/25.
//

import Foundation
import SwiftData

@Model
class Book {
    var title: String // These are called attributes
    var author: String
    var genre: String
    var review: String
    var rating: Int
    
    var date = Date.now /// Challenge #3 Part 1
    
    init(title: String, author: String, genre: String, review: String, rating: Int, date: Date) { /// Challnege #3 Part 2
        self.title = title
        self.author = author
        self.genre = genre
        self.review = review
        self.rating = rating
    }
}
