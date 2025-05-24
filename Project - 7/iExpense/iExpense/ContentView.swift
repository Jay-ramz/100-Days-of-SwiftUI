//
//  ContentView.swift
//  iExpense
//
//  Created by Jay Ramirez on 12/11/24.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    let currencyCode: String
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
            items = decodedItems
            return
            }
        }
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    ForEach(expenses.items) { item in
                        if item.type == "Personal" {
                            HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                                    .font(.subheadline)
                            }
                            Spacer()
                            Text(item.amount, format: .currency(code: item.currencyCode))
                                .foregroundStyle(item.amount < 10 ? .black.opacity(0.3) : (item.amount < 100 ? .black.opacity(0.6) : .black))
                            }
                        }
                    }
                    .onDelete(perform: { indexSet in
                        removeAtOffset(at: indexSet)
                    })
                }
                Section("Business") {
                    ForEach(expenses.items) { item in
                    if item.type == "Business" {
                        HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                                .font(.subheadline)
                        }
                        Spacer()
                        Text(item.amount, format: .currency(code: item.currencyCode))
                            .foregroundStyle(item.amount < 10 ? .black.opacity(0.3) : (item.amount < 100 ? .black.opacity(0.6) : .black))
                    }
                    }
                }
                .onDelete(perform: { indexSet in
                    removeAtOffset(at: indexSet)
                })
                    
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink {
                    AddView(expenses: expenses)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    func removeAtOffset(at offset: IndexSet) {
        expenses.items.remove(atOffsets: offset)
    }
}

#Preview {
    ContentView()
}
