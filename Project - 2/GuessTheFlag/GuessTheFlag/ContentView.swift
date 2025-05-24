//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Jay Ramirez on 11/11/24.
// Next steps figure out flagtapped - You have to call the function to do an action however its not doing anything.

import SwiftUI
// A New struct must be created for a ViewModifier -- While troubleshooting, discovered that I cannot place the struct in the ContentView for it to be reusable
struct LargeBlueTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
            .bold()
    }
}

extension View {
    func largeBlueTitle() -> some View {
        self.modifier(LargeBlueTitle())
    }
}

struct ContentView: View {
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var gameOver = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var currentQuestion = 1
    @State private var totalQuestions = 8
    
    @State private var animationAmount = 0.0
    
    @State private var selectedFlag: Int? = nil

    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack(spacing: 15) {
                Text("Guess the Flag")
                    .largeBlueTitle()
                
                VStack(spacing: 20) {
                    Text("Tap the Flag Of")
                        .foregroundStyle(.white)
                        .font(.subheadline.weight(.heavy))
                    
                    Text(countries[correctAnswer])
                        .foregroundStyle(.white)
                        .font(.largeTitle.weight(.semibold))
                    
                    VStack(spacing: 20) {
                        ForEach(0..<3) { number in
                            Button {
                                withAnimation {
                                    selectedFlag = number
                                    animationAmount += 360
                                }
                                flagTapped(number)
                            } label: {
                                Image(countries[number])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 100)
                                    .clipShape(Capsule())
                                    .shadow(radius: 5)
                            }
                            .opacity(selectedFlag == nil || selectedFlag == number ? 1.0 : 0.25)
                            .scaleEffect(selectedFlag == number ? 1.0 : 0.75)
                            .rotation3DEffect(
                                .degrees(selectedFlag == number ? animationAmount : 0),
                                axis: (0, 1, 0)
                            )
                            .animation(.easeInOut(duration: 0.7), value: selectedFlag)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    Spacer()
                    Spacer()

                    Text("Score: ?")
                        .foregroundStyle(.white)
                        .font(.title.bold())

                    Spacer()
                }
                .padding()
                
                Text("Your Score: \(userScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is: \(userScore)")
        }
        .alert("Game Over", isPresented: $gameOver) {
            Button("Restart", action: restartGame)
        } message: {
            Text("Your final score is: \(userScore)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct! That's the flag of \(countries[number])"
            userScore += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
            userScore -= 1
        }
        
        if currentQuestion == totalQuestions {
            gameOver = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        currentQuestion += 1
        selectedFlag = nil
    }
    
    func restartGame() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        userScore = 0
        currentQuestion = 1
    }
}

struct FlagImage: View {
    var imageName: String

    var body: some View {
        Image(imageName)
            .renderingMode(.original)
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 100)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 2))
            .shadow(color: .black, radius: 2)
    }
}

#Preview {
    ContentView()
}
// #3 requires a new alert - where its keeping track how many questions have been answered (right or wrong). This alert has to stop on 8 to stop the game and restart to the beginning.
