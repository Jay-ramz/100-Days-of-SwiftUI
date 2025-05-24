//
//  ContentView.swift
//  BrainGame
//
//  Created by Jay Ramirez on 11/19/24.
//
// Issues: need to find the appropriate location for padding to bring down "reset"
import SwiftUI

struct ContentView: View {
    
    @State private var options = ["🪨", "🗒","✂️"] // This is the rock, paper, & scissors
    @State private var needToWin = Bool.random() // This will return true or false - Whether the player needs to win
    @State private var rounds = 0 // # of rounds
    let computerNo = Int.random(in: 0...2) // This chooses a random number between 0 and 2 - Part of game moves
    var toWin: String {
        if options[computerNo] == "🪨" {
            return "🗒"
        } else if options[computerNo] == "🗒" {
            return "✂️"
        } else {
            return "🪨"
        } // returns outcome winning response
    }
    
    @State private var alertPresented = false // This shows the alert
    @State private var outcomeTitle = "" // This will become the alert title
    @State private var wasCorrect = false // This is used to change the message in the alert
    @State private var score = 0 // Score keeper
    @State private(set) var highScore = 0 // This records the high score
    @State private var hasEnded = false // used as an alert after the last round
    
    var body: some View {
        ZStack {
            Image("Hands")
                .opacity(0.6)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Rock, Paper, Scissors")
                    .padding()
                    .scaledToFit()
                    .font(.largeTitle)
                    .bold()
                Text("Imaginary Friend Chose")
                    .padding()
                    .font(.title2)
                    .bold()
                Text(options[computerNo])
                    .font(.largeTitle)
//                Text("You must...")
//                    .padding()
//                    .font(.title3)
//                    .bold()
                Text(needToWin ? "Win" : "Lose")
                    .foregroundColor(needToWin ? .green : .red)
                    .padding()
                    .font(.largeTitle)
                    .bold()
//                Text("Choose wisely...")
//                    .padding(30)
//                    .bold()
                HStack {
                    Spacer()
                    Button("🪨") {
                        let userOption = "🪨"
                        chosen(user: userOption)
                    } .foregroundColor(.yellow)

                    Spacer()
                    Button("🗒") {
                        let userOption = "🗒"
                        chosen(user: userOption)
                    }.foregroundColor(.black)
                    Spacer()
                    Button("✂️") {
                        let userOption = "✂️"
                        chosen(user: userOption)
                    } .foregroundColor(.blue)
                        .font(.largeTitle)
                    Spacer()
                }
                Spacer()
                VStack{
                    Text("Score: \(score)")
                        .padding(10)
                        .bold()
                    VStack{
                        Text("High Score: \(highScore)")
                            .padding(30)
                            .bold()
                        HStack {
                            Button("Reset") {
                                highScore = 0
                            }.foregroundColor(.blue)
                                .bold()
                                .padding()
                        }
                    }
                }
                // Need to find padding to bring down reset. High Score is elevated. I was able to by changing the padding to 30 (line94). Now I have to bring down High Score
            } .alert(outcomeTitle, isPresented: $alertPresented) {
                Button("Next", action: nextQuestion)
            } message: {
                if wasCorrect == true {
                    Text("Your score is \(score)")
                } else {
                    Text("Try again")
                }
            } .alert("Game Over", isPresented: $hasEnded) {
                Button("Restart game", action: gameOver)
            } message: {
                if wasCorrect == true {
                    Text("Correct! Your final score was \(score)")
                } else {
                    Text("Wrong! Your final score was \(score)")
                }
            }
        }
    }
    // This was super difficult to build. ChatGPT was my best friend.
    // Some of the difficulties were: Trying to figure out "Chosen(User: "") is and how to incorporate it into my code. In general, creating functions has been difficult. This code required a lot of "if scenario's"
    func chosen(user: String) {
        rounds += 1
        if user == toWin && needToWin == true {
            outcomeTitle = "Correct!"
            wasCorrect = true
            score += 1
        }
        if user == toWin && needToWin == false {
            outcomeTitle = "Wrong!"
            wasCorrect = false
        }
        if user != toWin && needToWin == true { // != is a comparison operator used to check if two values are not equal
            outcomeTitle = "Wrong!"
            wasCorrect = false
        }
        if user != toWin && needToWin == false {
            outcomeTitle = "Correct!"
            wasCorrect = true
            score += 1
        }
        if rounds == 10 {
            hasEnded = true
        } else {
            alertPresented = true
        }
        
    }
    func nextQuestion() {
        options.shuffle()
        needToWin = Bool.random()
    }
    func gameOver() {
        nextQuestion()
        rounds = 0
        if score > highScore {
            highScore = score
        }
        score = 0
    }
}

#Preview {
    ContentView()
}
