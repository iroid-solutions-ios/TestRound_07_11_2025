//
//  SubcriptionViewModel.swift
//  Demo
//
//  Created by iMac on 07/11/25.
//

import SwiftUI

final class SubcriptionViewModel : ObservableObject {
    static let shared = SubcriptionViewModel()
    @Published var subscriptions : [Subcription] = [
        Subcription(service: Service.demo[0], category: Category.demo[0], frequency: Frequency.demo[0], amount: 100, startDate: Date(), isActice: true),
        Subcription(service: Service.demo[1], category: Category.demo[2], frequency: Frequency.demo[2], amount: 399, startDate: Date(), isActice: true),
        Subcription(service: Service.demo[2], category: Category.demo[3], frequency: Frequency.demo[1], amount: 499, startDate: Date(), isActice: false),
        Subcription(service: Service.demo[3], category: Category.demo[4], frequency: Frequency.demo[1], amount: 59, startDate: Date(), isActice: true)
    ]
    private init(){
        
    }
}
