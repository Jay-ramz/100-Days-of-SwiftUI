//
//  AddBookView.swift
//  Bookworm
//
//  Created by Jay Ramirez on 1/13/25.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var showingAddScreen = false
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = "Fantasy"
    @State private var review = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var isAllAreaValid: Bool { /// Challenge #1 Part 2: confirm that all fields meet conditions set by whitespace
        if title.isBlank || author.isBlank || rating<1 || review.isBlank {
            return false
        }
        
        return true
        
    }
                                                 
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name of Book", text: $title)
                    TextField("Author's Name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section("Write a Review") {
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                }
                
                Section { /// Challenge #1: Part 3
                    Button("Save") {
                        let newBook = Book(title: title, author: author, genre: genre, review: review, rating: rating, date: Date.now) /// Challenge #3 part 3 - added date: Date.now
                        modelContext.insert(newBook)
                        dismiss()
                    }
                    .disabled(isAllAreaValid == false)
                }
            }
            .navigationTitle("Add Book")
        }
    }
}

extension String { //// Challenge #1
    var isBlank: Bool {
        allSatisfy({ $0.isWhitespace})
    }
}

#Preview {
    AddBookView()
}
