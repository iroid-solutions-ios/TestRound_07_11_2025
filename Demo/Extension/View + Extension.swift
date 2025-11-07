//
//  View + Extension.swift
//  Demo
//
//  Created by iMac on 07/11/25.
//
import SwiftUI

extension View {
    func attachSheets(viewModel : CreateSubscriptionViewModel) -> some View {
        self.modifier(SheetModifier(viewModel: viewModel))
    }
}
