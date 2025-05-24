//
//  CustomDividerView.swift
//  MoonLight
//
//  Created by Jay Ramirez on 12/29/24.
//

import SwiftUI

struct CustomDividerView: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundColor(.lightBackground)
            .padding(.vertical)
    }
}

#Preview {
    CustomDividerView()
}
