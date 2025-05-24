//
//  UsersView.swift
//  SwiftDataProject
//
//  Created by Jay Ramirez on 1/17/25.
//

import SwiftData
import SwiftUI

struct UsersView: View {
    @Environment(\.modelContext) var modelContext
    @Query var users: [User]
    
    var body: some View {
        List(users) { user in
            HStack {
                
                Text(user.name)
                
                Spacer()
                
                Text(String(user.unwrappedJobs.count))
                    .fontWeight(.black)
                    .padding(.horizontal)
                    .padding(.vertical)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
            }
        }
        .onAppear(perform: addSample)
    }
        init(minimumJoinDate: Date, sortOrder: [SortDescriptor<User>]) {
            _users = Query(filter: #Predicate<User> { user in
                user.joinDate >= minimumJoinDate
            }, sort: sortOrder)
        }
        
        func addSample() {
            let user1 = User(name: "Piper Chapman", city: "New York", joinDate: .now)
            let job1 = Job(name: "Organize Sock Drawer", priority: 3)
            let job2 = Job(name: "Make plans with Alex", priority: 4)
            
            modelContext.insert(user1)
            
            user1.jobs?.append(job1)
            user1.jobs?.append(job2)
    }
}

#Preview {
    UsersView(minimumJoinDate: .now, sortOrder: [SortDescriptor(\User.name)])
        .modelContainer(for: User.self)
}
