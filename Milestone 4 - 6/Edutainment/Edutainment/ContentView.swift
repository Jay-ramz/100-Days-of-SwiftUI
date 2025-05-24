//
//  ContentView.swift
//  Edutainment
//
//  Created by Jay Ramirez on 12/6/24.
//

import SwiftUI

struct Question {
    let text: String
    let answer: Int
}

struct ContentView: View {
    @State private var isGameActive = false // indicates if the game is active
    @State private var questions: [Question] = [] // stores the list of questions for the game
    @State private var currentQuestionIndex = 0 // tracking + displays question to user
    @State private var score = 0 // keeps track of score
    @State private var maxMultiplier = 12 // Defines maximum mulitplier
    @State private var questionCount = 20 // number of questions
    @State private var userAnswer = "" // placeholder for the current answer
    
    let questionOptions = [5, 10, 20]
    
    
    var body: some View {
        NavigationView {
            if isGameActive {
                
                VStack {
                    if currentQuestionIndex < questions.count {
                        Text(questions[currentQuestionIndex].text)
                            .font(.largeTitle)
                            .padding()
                        
                        TextField("Your Answer", text: $userAnswer)
                            .keyboardType(.numberPad)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button("Submit") {
                            let correctAnswer = questions[currentQuestionIndex].answer
                            if Int(userAnswer) == correctAnswer {
                                score += 1
                            }
                            userAnswer = ""
                            currentQuestionIndex += 1
                        }
                    } else {
                        
                        Text("Game Over")
                        Text("Your score: \(score)/\(questions.count)")
                            .font(.headline)
                        
                        Button("Play Again") {
                            resetGame()
                        }
                    }
                }
                .padding()
                .navigationTitle("Are you smarter than a 4th Grader?")
            } else {
                
                Form {
                    Section(header: Text("Multiplication Range")) {
                        Stepper("Up to \(maxMultiplier)", value: $maxMultiplier, in: 1...12)
                    }
                    
                    Section(header: Text("Number of Questions")) {
                        Picker("Questions", selection: $questionCount) {
                            ForEach(questionOptions, id: \.self) { count in
                                Text("\(count)")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Button("Start Game") {
                        startGame()
                    }
                }
                .navigationTitle("Choose Your Settings")
            }
        }
        
    }
    
    func generateQuestions(maxMultiplier: Int, count: Int) -> [Question] {
        (1...count).map { _ in
            let first = Int.random(in: 1...maxMultiplier)
            let second = Int.random(in: 1...maxMultiplier)
            return Question(text: "\(first) x \(second)", answer: first * second)
        }
    }
    func startGame() {
        questions = generateQuestions(maxMultiplier: maxMultiplier, count: questionCount)
        isGameActive = true
        currentQuestionIndex = 0
        score = 0
    }
    
    func resetGame() {
        isGameActive = false
        userAnswer = ""
    }
}

#Preview {
    ContentView()
}
