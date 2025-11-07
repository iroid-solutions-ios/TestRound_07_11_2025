//
//  Category.swift
//  Demo
//
//  Created by iMac on 07/11/25.
//

import SwiftUI

struct Category: Identifiable, Codable {
    var id: Int
    var name: String
    var img: String
    
    static let demo: [Category] = [
        Category(id: 1, name: "Subcription", img: "subscription_icon"),
        Category(id: 2, name: "Utility", img: "utility_icon"),
        Category(id: 3, name: "Card Payment", img: "card_payment"),
        Category(id: 4, name: "Loan", img: "load_icon"),
        Category(id: 5, name: "Rent", img: "rent_icon")
    ]
}
