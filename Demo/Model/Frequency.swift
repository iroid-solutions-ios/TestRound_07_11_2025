//
//  Frequency.swift
//  Demo
//
//  Created by iMac on 07/11/25.
//

import SwiftUI

struct Frequency: Identifiable, Codable {
    var id: Int
    var name: String
    
    static let demo: [Frequency] = [
        Frequency(id: 1, name: "Weekly"),
        Frequency(id: 2, name: "Monthly"),
        Frequency(id: 3, name: "Annually")
    ]
}
