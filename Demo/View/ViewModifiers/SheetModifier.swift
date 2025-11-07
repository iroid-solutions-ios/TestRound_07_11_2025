//
//  SheetModifier.swift
//  Demo
//
//  Created by iMac on 07/11/25.
//

import SwiftUI
struct SheetModifier: ViewModifier {
    @ObservedObject var viewModel: CreateSubscriptionViewModel
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $viewModel.isShowServices) {
                ServicesView(
                    selectedCategory: $viewModel.selectedService,
                    selectedCat: viewModel.selectedService
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $viewModel.isShowCategory) {
                CategoriesView(
                    selectedCat: viewModel.selectedCategory,
                    selectedCategory: $viewModel.selectedCategory
                )
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $viewModel.isShowDate) {
                StartDateView(selectedDate: $viewModel.startDate)
                    .presentationDetents([.height(300)])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $viewModel.isShowFrequency) {
                FrequncyView(
                    selectedFrequncy: $viewModel.selectedFrequency,
                    selectedCat: viewModel.selectedFrequency
                )
                .presentationDetents([.height(240)])
                .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $viewModel.showAmountInput) {
                AmountInputView(viewModel: viewModel)
            }
    }
}
