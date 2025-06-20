//
//  EditCards.swift
//  FlashZilla
//
//  Created by Jay Ramirez on 6/17/25.
//

import Foundation

import SwiftUI

struct EditCards: View {
    @Environment(\.dismiss) var dismiss
    //@State private var cards = [Card]()
    @State private var cards = DataManager.load()
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add Card", action: addCard)
                }
                
                Section {
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards[index].prompt)
                                .font(.headline)
                            Text(cards[index].answer)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done", action: done)
            }
            .listStyle(.grouped)
        }
    }
    func done() {
        dismiss()
    }
    
    func addCard() {
            let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
            let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
            guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }
            
            let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
            cards.insert(card, at: 0)
            DataManager.save(cards)
            newPrompt = ""
            newAnswer = ""
        }
        
        func removeCards(at offsets: IndexSet) {
            cards.remove(atOffsets: offsets)
            DataManager.save(cards)
        }
        
    }

    #Preview {
        EditCards()
    }
