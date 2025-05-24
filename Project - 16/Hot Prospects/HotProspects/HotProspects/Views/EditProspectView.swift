//
//  EditProspectView.swift
//  HotProspects
//
//  Created by Jay Ramirez on 5/24/25.
//

import SwiftUI

// ✅ challenge 2
struct EditProspectView: View {
    @State var prospect: Prospect
    var body: some View {
        Form {
            TextField("Name", text: $prospect.name)
                .textContentType(.name)
                .font(.title)
            
            TextField("Email address", text: $prospect.emailAddress)
                .textContentType(.emailAddress)
                .font(.title)
        }
    }
}

#Preview {
    EditProspectView(prospect: Prospect(name: "", emailAddress: "", isContacted: false))
}
