//
//  CreateSubscriptionViewModel.swift
//  Demo
//
//  Created by iMac on 07/11/25.
//


import SwiftUI
import Combine

class CreateSubscriptionViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isShowServices: Bool = false
    @Published var isShowCategory: Bool = false
    @Published var isShowFrequency: Bool = false
    @Published var isShowDate: Bool = false
    @Published var showAmountInput: Bool = false
    @Published var isActive: Bool = false
    
    @Published var amount: Double = 0
    @Published var selectedService: Service?
    @Published var selectedFrequency: Frequency = Frequency.demo[0]
    @Published var startDate: Date = Date()
    @Published var selectedCategory: Category = Category.demo[0]
    @Published var amountText: String = ""
    
    // MARK: - Computed Properties
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: startDate)
    }
    
    var formattedAmount: String {
        if amount == 0 {
            return "$0"
        } else {
            return String(format: "$%.2f", amount)
        }
    }
    
    var isValid: Bool {
        return selectedService != nil
    }
    
    var canSave: Bool {
        return isValid
    }
    
    // MARK: - Methods
    func saveSubscription() {
        guard let service = selectedService else { return }
        
        let subscription = Subcription(
            service: service,
            category: selectedCategory,
            frequency: selectedFrequency,
            amount: amount,
            startDate: startDate,
            isActice: isActive
        )
        
        SubcriptionViewModel.shared.subscriptions.append(subscription)
    }
    
    func updateAmount(from text: String) {
        if let amountValue = Double(text) {
            amount = amountValue
        }
        amountText = ""
    }
    
    func resetAmountInput() {
        amountText = ""
    }
    
    func reset() {
        amount = 0
        selectedService = nil
        selectedFrequency = Frequency.demo[0]
        startDate = Date()
        selectedCategory = Category.demo[0]
        isActive = false
        amountText = ""
    }
}
