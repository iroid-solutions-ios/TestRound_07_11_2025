//
//  EditSubscriptionViewModel.swift
//  Demo
//
//  Created by iMac on 07/11/25.
//

import SwiftUI

final class EditSubscriptionViewModel: ObservableObject {
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

    @Published private(set) var index: Int

    // MARK: - Dependencies
    private let subscriptionsVM: SubcriptionViewModel

    // MARK: - Init
    init(index: Int, subscriptionsVM: SubcriptionViewModel = .shared) {
        self.index = index
        self.subscriptionsVM = subscriptionsVM
        loadSubscription()
    }

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

    var canSave: Bool {
        return selectedService != nil && subscriptionsVM.subscriptions.indices.contains(index)
    }

    // MARK: - Internal State Updates
    func updateIndex(_ newIndex: Int) {
        if index != newIndex {
            index = newIndex
        }
        loadSubscription()
    }

    func loadSubscription() {
        guard subscriptionsVM.subscriptions.indices.contains(index) else { return }
        let subscription = subscriptionsVM.subscriptions[index]

        selectedCategory = subscription.category
        selectedService = subscription.service
        selectedFrequency = subscription.frequency
        amount = subscription.amount
        isActive = subscription.isActice
        startDate = subscription.startDate
        amountText = String(subscription.amount)
    }

    func saveChanges() {
        guard canSave, let service = selectedService else { return }

        let updatedSubscription = Subcription(
            service: service,
            category: selectedCategory,
            frequency: selectedFrequency,
            amount: amount,
            startDate: startDate,
            isActice: isActive
        )

        subscriptionsVM.subscriptions[index] = updatedSubscription
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
}


