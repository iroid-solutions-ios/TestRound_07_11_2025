//
//  AmountInputView.swift
//  Demo
//
//  Created by iMac on 07/11/25.
//

import SwiftUI

struct AmountInputView: View {
    @ObservedObject var viewModel: CreateSubscriptionViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Enter Amount")
                    .font(.headline)
                    .padding(.top)
                
                TextField("0.00", text: $viewModel.amountText)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                HStack(spacing: 20) {
                    Button("Cancel") {
                        viewModel.resetAmountInput()
                        viewModel.showAmountInput = false
                    }
                    .foregroundColor(.gray)
                    
                    Button("Done") {
                        viewModel.updateAmount(from: viewModel.amountText)
                        viewModel.showAmountInput = false
                    }
                    .foregroundColor(Color("Primary500"))
                }
                .padding()
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.height(200)])
    }
}
