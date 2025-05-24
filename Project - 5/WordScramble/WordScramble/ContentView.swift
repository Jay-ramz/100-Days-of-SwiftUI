//
//  ContentView.swift
//  WordScramble
//
//  Created by Jay Ramirez on 12/2/24.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var score: Int {
        usedWords.reduce(0) { $0 + $1.count } + (usedWords.count * 10)
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
                Section { // Challenge # 3 where I made a section to track score 
                    Text("Score: \(score)")
                        .font(.headline)
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord) // new .onsubmit
            .onAppear(perform: startGame) // New .onAppear
            .alert(errorTitle, isPresented: $showingError) { } message: {
                Text(errorMessage)
            }
            .toolbar { // Challenge #2 create a tool bar to keep track of score
                Button("Restart") {
                    startGame()
                }
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard answer.count >= 3 else {
            wordError(title: "Word too short", message: "Words must be at least three letters long.") // Challenge #1 >= 3 the word is at least 3 letters long
            return
        }
        
        guard answer != rootWord else { // Challenge #1 prevents the word from being the same as the start word
            wordError(title: "Word not allowed", message: "You can't use the start word!")
            return
        }
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original!")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "word not possible", message: "You can't spell the word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you now!")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        
        newWord = ""
    }
    
    func startGame() {
        // Find the URL for start.txt
        if let startWordsURL = Bundle.main.url(forResource:"start", withExtension: "txt") {
            // Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL, encoding: .utf8) { // split the string up into an array of strings, splitting on line breaks - Had to ask lloyd about this
                let allWords = startWords.components(separatedBy: "\n") // \n refers to a line break
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool { // -> means returns
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
            
            func isReal(word: String) -> Bool {
                let checker = UITextChecker()
                let range = NSRange(location: 0, length: word.utf8.count)
                let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "end")
                return misspelledRange.location == NSNotFound // == is equal to
            }
            
            func wordError(title: String, message: String) {
                errorTitle = title
                errorMessage = message
                showingError = true
            }
}

#Preview {
    ContentView()
}
