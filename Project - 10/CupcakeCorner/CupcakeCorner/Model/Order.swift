//
//  Order.swift
//  CupcakeCorner
//
//  Created by Jay Ramirez on 1/6/25.
//

import Foundation

@Observable
class Order: Codable {
    
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _city = "city"
        case _streetAddress = "streetAddress"
        case _zip = "zip"
        
    }
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
        if specialRequestEnabled == false {
            extraFrosting = false
            addSprinkles = false
            }
        }
    }
    
    var extraFrosting = false
    var addSprinkles = false
    
    //// Challenge #3: Assigning values when the class object is created. No data requires an empty string
    var name: String
    var streetAddress: String
    var city: String
    var zip: String
    
    var hasValidAddress: Bool { //// #Challenge #1: added .isEmpty to ensure whitespace remains invalid
        if name.isEmpty || name.isBlank || streetAddress.isEmpty || streetAddress.isBlank || city.isEmpty || city.isBlank || zip.isEmpty || zip.isBlank {
            return false
        }
        
        return true
    }
    
    var cost: Decimal {
        // $2 per cake
        var cost = Decimal(quantity) * 2
        
        // Complicated cakes cost more
        cost += Decimal(type) / 2
        
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
    
    init() { //// Challenge #3: Assigning values when the class object is created. No data requires an empty string
        if let dataName = UserDefaults.standard.data(forKey: "addressItems") {
            if let decodedName = try? JSONDecoder().decode([String].self, from: dataName) {
                name = decodedName[0]
                streetAddress = decodedName[1]
                city = decodedName[2]
                zip = decodedName[3]
                return
            }
        }
        
        name = ""
        streetAddress = ""
        city = ""
        zip = ""
    }
}

extension String { //// Challenge 1: Creating white space - Invalid
    var isBlank: Bool {
        allSatisfy({$0.isWhitespace})
    }
}
