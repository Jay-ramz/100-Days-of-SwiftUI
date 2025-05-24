//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Jay Ramirez on 1/6/25.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var showingNoInternet = false /////Challenge #2 To show a warning when there is a problem with the internet connection
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string:"https://hws.dev/img/cupcakes@3x.jpg"),
                           scale: 3) { Image in
                    Image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total cost is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                
                .padding()
            }
        }
        .navigationTitle("Check Out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Thank You!", isPresented: $showingConfirmation) {
            Button("OK") { }
        
        } message: {
            Text(confirmationMessage)
        }
        .alert("Oops!", isPresented: $showingNoInternet) { ///// Challenge #2: Creating the informative alert that a user can receive
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please check your Internet connection.")
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let decodedOrder = try JSONDecoder ().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.type) x \(Order.types[decodedOrder.type].lowercased()) cupcakes are on the way)"
            showingConfirmation = true
        } catch {
            print("Check out failed: \(error.localizedDescription)")
            showingNoInternet = true ///Challenge #2 
        }
    }
}

#Preview {
    CheckoutView(order: Order())
}
