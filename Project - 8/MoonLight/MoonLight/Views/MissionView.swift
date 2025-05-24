//
//  MissionView.swift
//  MoonLight
//
//  Created by Jay Ramirez on 12/19/24.
//

import SwiftUI

struct MissionView: View {
    struct CrewMember: Hashable {
        let role: String
        let astronaut: Astronaut
    }
    let mission: Mission
    let crew: [CrewMember]
    var body: some View {
        ScrollView {
            VStack {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal) { width, axis in
                        width * 0.6
                    }
                VStack(alignment: .leading) {
                    CustomDividerView()
                    HStack(alignment: .bottom) {
                        Text(mission.displayName)
                            .font(.largeTitle.bold())
                        Text(mission.launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    Text(mission.description)
                    CustomDividerView()
                    Text("Crew")
                        .font(.largeTitle.bold())
                }
                .padding()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    ForEach(crew, id: \.role) { crewMember in
                        NavigationLink("\(crewMember.astronaut.name)", value: crewMember)
                    }
                }
                .navigationDestination(for: CrewMember.self) { member in
                    AstronautView(astronaut: member.astronaut)
                }
            }
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
    
    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.mission = mission
        self.crew = mission.crew.map { member in
            if let astronaut = astronauts[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        }
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    return MissionView(mission: missions[0], astronauts: astronauts)
        .preferredColorScheme(.dark)
}
