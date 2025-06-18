//
//  CardView.swift
//  FlashZilla
//
//  Created by Jay Ramirez on 6/17/25.
//

import SwiftUI

struct CardView: View {
    @State private var isShowingAnswer = false
    let card: Card
    
    @State private var offset = CGSize.zero
    
    var removal: (() -> Void)? = nil
    var sendedBack: (() -> Void)? = nil
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    
    @State private var isDragged = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    accessibilityDifferentiateWithoutColor
                    ? .white
                    : .white
                        .opacity(1 - Double(abs(offset.width / 50)))
                )
                .background(accessibilityDifferentiateWithoutColor ? nil : RoundedRectangle(cornerRadius: 25)
                    .fill(isDragged ? (offset.width > 0 ? .green : .red) : .white)
                            )
                .shadow(radius: 10)
            
            VStack {
                if accessibilityVoiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                    
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(offset.width / 5.0))
        .offset(x: offset.width * 5)
        .opacity(2 - Double(abs(offset.width / 50)))
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    isDragged = true
                }
                .onEnded { _ in
                    isDragged = false
                    if abs(offset.width) > 100 {
                        if offset.width > 0 {
                            removal?()
                        } else if offset.width < 0 {
                            sendedBack?()
                        }
                    } else {
                        offset = .zero
                    }
                }
            )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.bouncy, value: offset)
    }
}

#Preview {
    CardView(card: .example)
}
