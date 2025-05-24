//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Jay Ramirez on 1/6/25.
//

import SwiftUI

struct AddressView: View {
    @Bindable var order: Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }
            
            Section { //// Challenge #3: Saving user data like delivery address in userdefaults
                NavigationLink("Check out") {
                    CheckoutView(order: order)
                        .onAppear {
                            let addressItems = [order.name, order.streetAddress, order.city, order.zip]
                            if let encoded = try? JSONEncoder().encode(addressItems) {
                                UserDefaults.standard.set(encoded, forKey: "addressItems")
                                print("Address items recorded")
                            }
                            
                        }
                }
            }
            .disabled(order.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddressView(order: Order())
}
