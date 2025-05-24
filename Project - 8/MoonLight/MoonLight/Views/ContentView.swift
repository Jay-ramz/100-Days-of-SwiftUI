//
//  ContentView.swift
//  MoonLight
//
//  Created by Jay Ramirez on 12/17/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isGridView = false
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: 150))
        ]
        NavigationStack {
            ScrollView {
                if isGridView {
                    LazyVGrid(columns: columns) {
                        ForEach(missions) { mission in
                            NavigationLink {
                                MissionView(mission: mission, astronauts: astronauts)
                            } label: {
                                VStack {
                                    Image(mission.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .padding()
                                    VStack {
                                        Text(mission.displayName)
                                            .font(.headline)
                                        Text(mission.formattedLaunchDate)
                                            .font(.caption)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(.lightBackground)
                                }
                                .clipShape(.rect(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.lightBackground)
                                )
                            }
                            .padding([.horizontal, .bottom])
                        }
                    }
                } else {
                    LazyVStack {
                        ForEach(missions) { mission in
                            NavigationLink {
                                MissionView(mission: mission, astronauts: astronauts)
                            } label: {
                                HStack {
                                    Image(mission.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .padding()
                                    VStack {
                                        Text(mission.displayName)
                                            .font(.headline)
                                        Text(mission.formattedLaunchDate)
                                            .font(.caption)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(.lightBackground)
                                }
                                .clipShape(.rect(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.lightBackground)
                                )
                            }
                            .padding([.horizontal, .bottom])
                        }
                    }
                }
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
            .toolbar(content: {
                Button(action: {
                    isGridView.toggle()
                }, label: {
                    Text(isGridView ? "View as a List" : "View as a Grid")
                })
            })
        }
    }
}

#Preview {
    ContentView()
}
